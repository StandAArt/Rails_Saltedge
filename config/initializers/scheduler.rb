require 'rufus-scheduler'
s = Rufus::Scheduler.singleton

s.every '15m' do
    ConnectionsHelper.refresh_connections
end