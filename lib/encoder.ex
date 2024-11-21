defmodule Xav.Encoder do
  use Zig,
    otp_app: :xav,
    resources: [:EncoderResource],
    c: [
      link_lib: "/opt/homebrew/Cellar/ffmpeg/7.1_1/lib/libavcodec.dylib",
      include_dirs: ["/opt/homebrew/Cellar/ffmpeg/7.1_1/include"],
      lib_dirs: ["/opt/homebrew/Cellar/ffmpeg/7.1_1/lib"]
    ]

  ~Z"""
  const beam = @import("beam");
  const root = @import("root");
  const avcodec = @cImport(@cInclude("libavcodec/avcodec.h"));

  pub const SubtitleType = enum(c_int) {
      none = avcodec.SUBTITLE_NONE,
      bitmap = avcodec.SUBTITLE_BITMAP,
      text = avcodec.SUBTITLE_TEXT,
      ass = avcodec.SUBTITLE_ASS,
  };

  const Encoder = struct { path: []const u8 };

  pub const EncoderResource = beam.Resource(Encoder, root, .{});

  pub fn new(path: []const u8) !EncoderResource {
      return EncoderResource.create(.{ .path = path }, .{});
  }

  pub fn get_path(encoder: EncoderResource) []const u8 {
      return encoder.unpack().path;
  }

  pub fn get_subtitle(subtitle: i32) SubtitleType {
      return @enumFromInt(subtitle);
  }
  """
end
