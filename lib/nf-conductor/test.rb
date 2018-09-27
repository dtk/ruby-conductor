#!/usr/bin/env ruby

require 'nf-conductor'
Conductor.initialize('development', verbose: true)
Conductor.config.service_uri = 'http://dario.dtk.io:5001'

Conductor::Tasks.get_all_poll_data