namespace :maintenance do
  task create_cvd_org: :environment do
    hsh = {
      name: 'Civils de la Défense',
      name_business_owner: 'le Ministère des Armées',
      administrator_email_suffix: '@intradef.gouv.fr',
      subdomain: 'cvd',
      domain: 'civilsdeladefense.fabnum.fr'
    }
    organization = Organization.create!(hsh)
    Administrator.update_all(organization_id: organization.id)
    User.update_all(organization_id: organization.id)
    JobApplication.update_all(organization_id: organization.id)
    JobOffer.update_all(organization_id: organization.id)

    root_page = organization.pages.create!({
      title: 'Plateforme de recrutement de personnel civils contractuels pour le Ministère des Armées',
      only_link: false
    })
    branch_1_page_1 = organization.pages.create!({
      parent: root_page,
      title: 'Mentions légales',
      only_link: false,
      body: 'Ici afficher mentions légales'
    })
    branch_1_page_2 = organization.pages.create!({
      parent: branch_1_page_1,
      title: 'Conditions générales d’utilisation',
      only_link: false,
      body: 'Ici afficher conditions générales d’utilisation'
    })
    branch_1_page_3 = organization.pages.create!({
      parent: branch_1_page_2,
      title: 'Politique de confidentialité',
      only_link: false,
      body: 'Ici afficher politique de confidentialité'
    })
    branch_1_page_4 = organization.pages.create!({
      parent: branch_1_page_3,
      title: 'Suivi d\'audience et vie privée',
      only_link: false,
      body: 'Ici afficher suivi d\'audience et vie privée'
    })

    branch_2_page_1 = organization.pages.create!({
      parent: root_page,
      title: 'Service-public.fr',
      only_link: true,
      url: 'https://www.service-public.fr'
    })
    branch_2_page_2 = organization.pages.create!({
      parent: branch_2_page_1,
      title: 'Legifrance.gouv.fr',
      only_link: true,
      url: 'https://www.legifrance.gouv.fr'
    })
    branch_2_page_3 = organization.pages.create!({
      parent: branch_2_page_2,
      title: 'Data.gouv.fr',
      only_link: true,
      url: 'https://www.data.gouv.fr'
    })
    branch_2_page_4 = organization.pages.create!({
      parent: branch_2_page_3,
      title: 'France.fr',
      only_link: true,
      url: 'https://www.france.fr'
    })
  end

  # needed when migrating from audited 4.8 to 4.9
  # see https://github.com/collectiveidea/audited/issues/517
  task migrate_audits_enum_to_new_format: :environment do
    class Audit < ActiveRecord::Base; end
    cases = {
      JobApplication => %w[state],
      JobOffer => %w[state most_advanced_job_applications_state]
    }

    cases.each do |klass, fields|
      fields.each do |field|
        Audit.where(auditable_type: klass.to_s)
             .where("audited_changes->'#{field}' IS NOT NULL").each do |audit|
          audited_change = audit.audited_changes[field]
          enum_list = klass.send(field.pluralize.to_sym)
          if audited_change.is_a?(Integer)
            # nothing to do
          elsif audited_change.is_a?(String)
            audited_changes = audit.audited_changes
            enum_str = audited_changes[field]
            enum_id = enum_list[enum_str]
            audited_changes[field] = enum_id
            audit.update_column :audited_changes, audited_changes
          elsif audited_change.is_a?(Array)
            if audited_change.all? { |x| x.is_a?(Integer) }
              # nothing to do
            elsif audited_change.all? { |x| x.is_a?(String) }
              audited_changes = audit.audited_changes
              enum_ary = audited_changes[field]
              enum_ids = enum_ary.map { |enum_str| enum_list[enum_str] }
              audited_changes[field] = enum_ids
              audit.update_column :audited_changes, audited_changes
            else
              debugger
            end
          else
            debugger
          end
        end
      end
    end
  end

  task fixup_duplicate_files: :environment do
    rel = JobApplicationFile.select(:job_application_file_type_id, :job_application_id)
                            .group(:job_application_file_type_id, :job_application_id)
                            .having('count(*) > 1')
    rel.each do |zombie|
      hsh = {
        job_application_file_type_id: zombie.job_application_file_type_id,
        job_application_id: zombie.job_application_id
      }
      files = JobApplicationFile.where(hsh).to_a
      by_is_validated = files.group_by(&:is_validated)
      by_is_validated_0 = by_is_validated[0] || []
      by_is_validated_1 = by_is_validated[1] || []
      by_is_validated_2 = by_is_validated[2] || []
      if by_is_validated_0.size == files.size
        # no file has been validated yet
        # we can destroy the oldest ones
        sorted_by_created_at = files.sort_by(&:created_at)
        the_last_one_to_keep = sorted_by_created_at.pop
        sorted_by_created_at.each do |file|
          destroy_file(file)
        end
      elsif by_is_validated_1.size == 1 && by_is_validated_2.size == 0
        # only one file flagged valid, no other touched
        # we can destroy the other
        (by_is_validated_0 + by_is_validated_2).each do |file|
          destroy_file(file)
        end
      elsif by_is_validated_2.size == 1 && by_is_validated_1.size == 0
        # only one file flagged invalid, no other touched
        # we can destroy the other
        (by_is_validated_0 + by_is_validated_1).each do |file|
          destroy_file(file)
        end
      else
        # we cannot do anything except destroying the oldest files
        sorted_by_created_at = files.sort_by(&:created_at)
        the_last_one_to_keep = sorted_by_created_at.pop
        sorted_by_created_at.each do |file|
          destroy_file(file)
        end
      end
    end
  end

  def destroy_file(file)
    begin
      file.destroy
    rescue Fog::OpenStack::Storage::NotFound => e
      Rails.logger.debug "Deletion failed for file #{file.inspect}"
    end
  end
end

