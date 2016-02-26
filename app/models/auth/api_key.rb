
class ApiKey
  belongs_to :created_by, class_name: User


  def regenerate!(updated_by)
    self.key = SecureRandom.hex(32)
    self.created_by = updated_by
    save!
  end
end
