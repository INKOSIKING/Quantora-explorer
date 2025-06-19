const blacklist = require('metro-config/src/defaults/exclusionList');

module.exports = {
  watchFolders: [],
  resolver: {
    blacklistRE: blacklist([
      /node_modules\/react-native\/ReactCommon\/react\/renderer\/debug\/tests\/.*$/,
      /node_modules\/react-native\/ReactCommon\/react\/renderer\/components\/rncore\/.*$/,
      /node_modules\/expo-web-browser\/android\/src\/main\/java\/.*$/,
      /node_modules\/expo-system-ui\/android\/src\/main\/res\/.*$/,
    ]),
    sourceExts: ['js', 'json', 'ts', 'tsx', 'jsx'],
  },
  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
  server: {
    useGlobalHotkey: false,
  },
  maxWorkers: 1,
  resetCache: true,
};
