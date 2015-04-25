class ShirtRequest < Sequel::Model
  self.strict_param_setting = false

  serialize_attributes :mash, :person, :company

  set_allowed_columns :email, :size, :name, :street_one,
                      :street_two, :city, :state, :zip

  def validate
    set_defaults

    validates_presence [:email, :size]
    validates_format /@/, :email, message: 'is not a valid email'
    validates_unique :email
    validates_includes  %w{small medium large}, :size

    if confirmed?
      validates_presence [:name, :street_one, :city, :state, :zip]
    end
  end

  def address?
    street_one?
  end

  def as_json(options = nil)
    {
      id:    id,
      email: email,
      size:  size,
      name:  name,
      street_one: street_one,
      street_two: street_two,
      city: city,
      state: state,
      zip: zip
    }
  end

  protected

  def geo_street_one
    [company.geo.street_number, company.geo.street_name].compact.join(' ')
  end

  def set_defaults
    if person?
      self.name ||= person.name.full_name
    end

    if company?
      self.street_one ||= geo_street_one
      self.street_two ||= company.geo.sub_premise
      self.city       ||= company.geo.city
      self.state      ||= company.geo.state
      self.zip        ||= company.geo.postal_code
    end
  end
end
