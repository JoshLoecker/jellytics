/// These are possible items to be retrieved from Jellyfin
///
/// Most used BaseItemKind is going to be "movie" or "episode"
/// Most used Field

enum BaseItemKind {
  aggregateFolder,
  audio,
  audioBook,
  basePluginFolder,
  book,
  boxSet,
  channel,
  channelFolderItem,
  collectionFolder,
  episode,
  folder,
  genre,
  manualPlaylistsFolder,
  movie,
  liveTvChannel,
  liveTvProgram,
  musicAlbum,
  musicArtist,
  musicGenre,
  musicVideo,
  person,
  photo,
  photoAlbum,
  playlist,
  playlistsFolder,
  program,
  recording,
  season,
  series,
  studio,
  trailer,
  tvChannel,
  tvProgram,
  userRootFolder,
  userView,
  video,
  year
}

enum Field {
  airTime,
  basicSyncInfo,
  canDelete,
  canDownload,
  channelImage,
  channelInfo,
  chapters,
  childCount,
  cumulativeRunTimeTicks,
  customRating,
  dateCreated,
  dateLastMediaAdded,
  dateLastRefreshed,
  dateLastSaved,
  displayPreferencesId,
  enableMediaSourceDisplay,
  etag,
  externalEtag,
  externalSeriesId,
  externalUrls,
  extraIds,
  genres,
  height,
  homePageUrl,
  inheritedParentalRatingValue,
  isHD,
  itemCounts,
  localTrailerCount,
  mediaSourceCount,
  mediaSources,
  mediaStreams,
  originalTitle,
  overview,
  parentId,
  path,
  people,
  playAccess,
  presentationUniqueKey,
  primaryImageAspectRatio,
  productionLocations,
  providerIds,
  recursiveItemCount,
  refreshState,
  remoteTrailers,
  screenshotImageTags,
  seasonUserData,
  seriesPresentationUniqueKey,
  seriesPrimaryImage,
  seriesStudio,
  serviceName,
  settings,
  sortName,
  specialEpisodeNumbers,
  specialFeatureCount,
  studios,
  syncInfo,
  taglines,
  tags,
  themeSongIds,
  themeVideoIds,
  width,
}
