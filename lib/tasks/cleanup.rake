#
# CLEANUP tasks
#
# Removing data that has become invalid.
#
# In an ideal world these would not be necessary. If you run any of these and
# they actually do sth. you probably want to find out why and remove the cause.
#

namespace :cg do
  namespace :cleanup do
    desc "Remove all participations where the entity does not exist anymore"
    task(:remove_dead_participations => :environment) do
      count = UserParticipation.where(dead_entity_sql('user')).delete_all
      puts "Removed #{count} User Participations."
      count = GroupParticipation.where(dead_entity_sql('group')).delete_all
      puts "Removed #{count} Group Participations."
    end

    desc "Remove all federatings where the group does not exist anymore"
    task(:remove_dead_federatings => :environment) do
      count = Federating.where(dead_entity_sql('group')).delete_all
      puts "Removed #{count} Federatings with outdated groups."
      count = Federating.where(dead_entity_sql('network', 'groups')).delete_all
      puts "Removed #{count} Federatings with outdated networks."
    end

    def dead_entity_sql(type, table = nil)
      table ||= type + 's';
      "#{type}_id NOT IN (SELECT id FROM #{table})"
    end

  end
end
