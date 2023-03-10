module Moderable
  extend ActiveSupport::Concern

  included do
    after_save :moderate, if: :should_run_after_save_callback?
  end

  class_methods do
    def moderable_columns(*column_names)
      @moderated_columns = column_names
    end

    def moderated_columns
      @moderated_columns ||= []
    end
  end

  private

  def moderate
    self.class.moderated_columns.each do |column_name|
      puts "Running"
      value = self.send(column_name)
      next if value.blank?

      prediction = JSON.parse(HTTParty.get("http://moderation.logora.fr/predict?text=#{value}").body)["prediction"]["0"]
      accepted = prediction < 0.5
      self.update_column(:is_accepted, accepted) unless accepted
    end
  end

  def should_run_after_save_callback?
    Post.moderated_columns.any? { |column| saved_change_to_attribute?(column.to_s) }
  end
end