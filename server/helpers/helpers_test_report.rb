module HelpersTestReport
  def get_duration(te)
    te.finished_at = DateTime.now unless te.finished_at.kind_of?(DateTime)
    te.started_at = DateTime.now unless te.started_at.kind_of?(DateTime)
    ((te.finished_at - te.started_at)*24*60*60).to_i
  end
end