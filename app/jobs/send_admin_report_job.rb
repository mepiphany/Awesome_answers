class SendAdminReportJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # @quedstion = Question.all
    

  end
end

# SendAdminReportJob.Perform_later()
