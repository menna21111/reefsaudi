/// Rating string constants used in feedback payloads.
const String kThumbsUp = 'thumbs_up';
const String kThumbsDown = 'thumbs_down';

/// Converts a rating string to the integer value expected by the backend.
///
/// Returns `1` for [kThumbsUp], `-1` for everything else.
int ratingToInt(String rating) => rating == kThumbsUp ? 1 : -1;
