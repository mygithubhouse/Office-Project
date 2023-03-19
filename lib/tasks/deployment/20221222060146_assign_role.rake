namespace :after_party do
  desc 'Deployment task: assign_role'
  task assign_role: :environment do
    puts "Running deploy task 'assign_role'"

    # Put your task implementation HERE.

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    role = BxBlockRolesPermissions::Role.find_by(name: 'Free')
    AccountBlock::Account.all.each do |account|
      account.update(role_id: role.id) unless account&.role&.present?
    end

    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end