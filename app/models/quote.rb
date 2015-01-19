
class Quote
  include Mongoid::Document
  field :text, type: String
  field :source, type: String
  field :url, type: String
  belongs_to :meaning
  has_many :suggestions, as: :target

  validates :text,
           :presence => true,
           :length => {:in => 15..200}

  validates :url,
            :url => true,
            :unless => Proc.new { |q| q.source == "Wordnet 3.0"}

  def self.suggestable_fields
    %(text source url)
  end

  def self.suggestable_children
    %()
  end

  def validate_suggestion(suggestion, errors)
    quote = self.dup
    suggestion["data"].each do |field, value|
      if !Quote.suggestable_fields.include?(field.to_s)
        errors.add field, "is not suggestable"
      end
      quote[field] = value
    end
    unless quote.valid?
      errors.add
    end
  end
end