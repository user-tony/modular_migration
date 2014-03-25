module ActiveRecord
  module Generators # :nodoc:
    class MigrationGenerator < Base # :nodoc:

      def create_migration_file
        set_local_assigns!
        validate_file_name!
        if migration_action.match(/(add|remove)/)
          table = table_name.singularize
          modular = table.gsub(/_/, '/').camelize.safe_constantize
          table = table.split('_')
          (table.size-1).times do |i|
            result = []
            table.each_with_index do |m, index|
              result << m
              result << (index == i ? '_' : '/') if index < table.size-1
              modular = result.join.camelize.safe_constantize if index == table.size-1
            end
            break if modular
          end unless modular
          migration = modular ? modular.to_s.underscore : []
        end
        migration = join_tables.map(&:singularize).join('_') if migration_action.match(/join/)
        migration = FileUtils.mkdir_p("db/migrate/#{migration}") if migration
        migration_file = File.join(migration.join('/'), "#{file_name}.rb")
        migration_template @migration_template, migration_file
      end

    end
  end
end
