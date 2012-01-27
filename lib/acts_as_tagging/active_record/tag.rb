# encoding: utf-8
module ActsAsTagging

  class Tag < ::ActiveRecord::Base

    def self.find_or_create(attr)

      object = new(attr)
      object = where(attr).first unless object.save(validate: false)
      object

    end # find_or_create

    def with_transaction_returning_status
      yield
    end # with_transaction_returning_status

    private

    def create_or_update(*args)

      begin
        super
      rescue ::ActiveRecord::RecordInvalid,
             ::ActiveRecord::RecordNotUnique
        false
      end

    end # create_or_update

  end # Tag

end # ActsAsTagging