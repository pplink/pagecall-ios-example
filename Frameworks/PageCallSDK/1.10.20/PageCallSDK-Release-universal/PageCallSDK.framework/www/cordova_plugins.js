cordova.define('cordova/plugin_list', function(require, exports, module) {
  module.exports = [
    {
      "id": "cordova-plugin-ionic-webview.IonicWebView",
      "file": "plugins/cordova-plugin-ionic-webview/src/www/util.js",
      "pluginId": "cordova-plugin-ionic-webview",
      "clobbers": [
        "Ionic.WebView"
      ]
    },
    {
      "id": "cordova-plugin-ionic-webview.ios-wkwebview-exec",
      "file": "plugins/cordova-plugin-ionic-webview/src/www/ios/ios-wkwebview-exec.js",
      "pluginId": "cordova-plugin-ionic-webview",
      "clobbers": [
        "cordova.exec"
      ]
    },
    {
      "id": "cordova-plugin-iosrtc.Plugin",
      "file": "plugins/cordova-plugin-iosrtc/dist/cordova-plugin-iosrtc.js",
      "pluginId": "cordova-plugin-iosrtc",
      "clobbers": [
        "cordova.plugins.iosrtc"
      ]
    }
  ];
  module.exports.metadata = {
    "cordova-plugin-add-swift-support": "2.0.2",
    "cordova-plugin-ionic-webview": "5.0.0",
    "cordova-plugin-iosrtc": "6.0.13",
    "cordova-plugin-whitelist": "1.3.4"
  };
});
