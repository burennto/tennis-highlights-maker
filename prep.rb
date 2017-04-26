require 'ostruct'

require_relative './src/video/video'
require_relative './src/video/video_editor'
require_relative './src/util/time_util'

SOURCES = [
  # OpenStruct.new(path: '~/Movies/FILE0009.mp4', start: '0:01:30', finish: '0:30:00'),
  # OpenStruct.new(path: '~/Movies/FILE0010.mp4', start: '0:00:00', finish: '0:27:00')
  OpenStruct.new(path: '~/Tennis/videos/round_3_2017_02_23/FILE0010.mp4', start: '0:27:45', finish: '0:30:00'),
  OpenStruct.new(path: '~/Tennis/videos/round_3_2017_02_23/FILE0011.mp4', start: '0:00:00', finish: '0:25:35'),
]

VideoEditor.trim_and_concat(SOURCES)
