Thread.new do
  $scheduler = Rufus::Scheduler.new

  $scheduler.every '30s', :first_at => Time.now + 1 do
    TestExecution.dequeue
  end

  $scheduler.every '10s', :first_at => Time.now + 1 do
    OperatingSystem.kill_executions
  end

  $scheduler.join
end
