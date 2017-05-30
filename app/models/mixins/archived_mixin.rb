module ArchivedMixin
  extend ActiveSupport::Concern

  included do
    scope :deleted, -> { where(:deleted => true) }
    scope :not_deleted, -> { where(:deleted => false) }

    belongs_to :old_ext_management_system, :foreign_key => :old_ems_id, :class_name => 'ExtManagementSystem'
  end

  def archived?
    deleted?
  end

  # Needed for metrics
  def my_zone
    if ext_management_system.present?
      ext_management_system.my_zone
    elsif old_ext_management_system.present?
      # Archived container entities need to retain their zone for metric collection
      # This makes the association more complex and might need a performance fix
      old_ext_management_system.my_zone
    end
  end
end
