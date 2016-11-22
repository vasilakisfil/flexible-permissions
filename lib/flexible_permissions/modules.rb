module FlexiblePermissions
  module RoleMethods
    attr_reader :record, :model

    def initialize(record, model = nil)
      @record = record
      @model = model || record.class
    end

    def fields(asked = nil)
      self.class::Fields.new(asked, record, model).resolve.concat(
        expects_include_fields_in_fields ? includes : []
      )
    end

    def includes(asked = nil)
      self.class::Includes.new(asked, record, model).resolve
    end

    def collection
      record
    end

    def expects_include_fields_in_fields
      false
    end
  end

  module SparsedMethods
    attr_reader :resolve, :model, :record, :asked
    def initialize(asked, record, model)
      @model = model
      @asked = asked
      @record = record
    end

    def resolve
      return with_transformations(defaults) if asked.blank?

      with_transformations(union(permitted, asked))
    end

    private
      def with_transformations(attributes)
        return attributes if transformations.blank?

        attributes.map{|x|
          transformations[x] ? transformations[x] : x
        }.flatten
      end

      def transformations
        {}
      end

      def permitted
        []
      end

      def defaults
        permitted
      end

      def union(permitted, asked = nil)
        return permitted unless asked.is_a?(Array)

        permitted.map(&:to_sym) & asked.map(&:to_sym)
      end

      def collection?
        record.kind_of? ActiveRecord::Relation
      end

      def resource?
        !collection?
      end
  end

  module SparsedFieldMethods
    include SparsedMethods

    private
      def permitted
        model.attribute_names.map(&:to_sym)
      end
  end

  module SparsedIncludeMethods
    include SparsedMethods

    private
      def permitted
        model.reflect_on_all_associations.map(&:name).map(&:to_sym)
      end
  end
end
