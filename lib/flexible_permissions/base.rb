module FlexiblePermissions
  class Base
    include RoleMethods

    class Fields
      include SparsedFieldMethods
    end

    class Includes
      include SparsedIncludeMethods
    end

    #for AMS basically...
    def expects_include_fields_in_fields
      true
    end
  end
end

