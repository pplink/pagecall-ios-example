/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        // cordova settings
        var cordova = window.cordova;
        if (cordova && cordova.plugins && cordova.plugins.iosrtc && cordova.platformId === 'ios') {
            // Expose WebRTC and GetUserMedia SHIM as Globals (Optional)
            // Alternatively WebRTC API will be inside cordova.plugins.iosrtc namespace
            //cordova.plugins.iosrtc.registerGlobals();
            
            // Enable iosrtc debug (Optional)
            cordova.plugins.iosrtc.debug.enable('iosrtc*');
            //cordova.plugins.iosrtc.debug.enable(false);
                        
            // use console log
            // https://cordova.apache.org/announcements/2017/09/08/ios-release.html
//            var logger = cordova.require('cordova/plugin/ios/logger');
//            logger.useLogger(true);
//            logger.level(logger.ERROR);
            
            // load adapter.js
            var adapterVersion = 'latest';
            var script = document.createElement("script");
            script.type = "text/javascript";
            script.src = "https://webrtc.github.io/adapter/adapter-" + adapterVersion + ".js";
            script.async = false;
            document.getElementsByTagName("head")[0].appendChild(script);
            console.log('Load adapter.js');
        }
        
        document.addEventListener('pause', this.onPause, false);
        document.addEventListener('resume', this.onResume, false);
        
        this.receivedEvent('deviceready');
    },
    
    onPause: function() {
        console.log('PageCallMobile onPause');
        if (window['iosCordovaOnPause']) {
            console.log('PageCallMobile iosCordovaOnPause');
            window['iosCordovaOnPause']();
        }
    },
    
    onResume: function() {
        console.log('PageCallMobile onResume');
        // Reconnect
        if (window['iosCordovaOnResume']) {
            console.log('PageCallMobile iosCordovaOnResume');
            window['iosCordovaOnResume']();
        }
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        // var parentElement = document.getElementById(id);
        // var listeningElement = parentElement.querySelector('.listening');
        // var receivedElement = parentElement.querySelector('.received');
        //
        // listeningElement.setAttribute('style', 'display:none;');
        // receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

app.initialize();

function alertDismissed() {
    // do something
}

function cleanUpBodyAndHead() {
    var destroy = window['__destroyTrigger'];
    if (destroy) {
        destroy();
    }
    
    var head = document.head;
    var headParent = head.parentNode;
    headParent.removeChild(head);
    headParent.appendChild(document.createElement('head'));
    
    var body = document.body;
    var bodyParent = body.parentNode;
    bodyParent.removeChild(body);
    bodyParent.appendChild(document.createElement('body'));
    
    bodyParent.className = '';
}

function mapDOM(element, json) {
  var treeObject = {};
  var parser;
  var docNode;

  // If string convert to document Node
  if (typeof element === "string") {
    if (DOMParser) {
      parser = new DOMParser();
      docNode = parser.parseFromString(element, "text/html");
    } else {
      console.error('DOMParser required');
    }
    element = docNode.firstChild;
  } else {
    console.log('Input is not a string, It is a ', typeof element);
  }

  //Recursively loop through DOM elements and assign properties to object
  function treeHTML(element, object) {
    object["type"] = element.nodeName;
    var nodeList = element.childNodes;
    if (nodeList !== null) {
      if (nodeList.length) {
        object["content"] = [];
        for (var i = 0; i < nodeList.length; i++) {
          let nodeType = nodeList[i].nodeType
          if (nodeType === 8 /* Comment */) return;
          if (nodeType === 3) {
            object["content"].push(nodeList[i].nodeValue);
          } else {
            object["content"].push({});
            treeHTML(nodeList[i], object["content"][object["content"].length - 1]);
          }
        }
      }
    }
    if (element.attributes !== null) {
      if (element.attributes.length) {
        object["attributes"] = {};
        for (var i = 0; i < element.attributes.length; i++) {
          object["attributes"][element.attributes[i].nodeName] = element.attributes[i].nodeValue;
        }
      }
    }
  }

  treeHTML(element, treeObject);

  return (json) ? JSON.stringify(treeObject) : treeObject;
}

function loadHtml(html) {
  var json = mapDOM(html, false);
  console.log('json', json);
  (function (map, window) {
    if (!window) console.error('global variable \'window\' is needed');

    var rootNode = window.document;
    var scriptQueue = [];

    var setAttribute = function (currentNode, attributes) {
      for (var attrName in attributes) {
        currentNode.setAttribute(attrName, attributes[attrName]);
      }
    };

    var makeCurrentNode = function (elem) {
      var elemType = typeof elem;
      var elemTag;
      var existingNode;
      var currentNode;

      if (elemType === 'string') {
        currentNode = document.createTextNode(elem);
      } else if (elemType === 'object' && elem) {
        elemTag = elem.type && elem.type.toLowerCase();
        // html, head, body는 원래 있던 걸 쓴다.
        if (elemTag === 'html' || elemTag === 'head' || elemTag === 'body') {
          existingNode = document.getElementsByTagName(elemTag)[0];
          if (existingNode) {
            console.log('node exists :', elemTag);
            currentNode = existingNode;
          } else {
            console.log('node not exists :', elemTag);
            currentNode = document.createElement(elemTag);
          }
        } else {
          currentNode = document.createElement(elemTag);
        }
      } else {
        currentNode = document.createTextNode('null');
        console.error('unexpected elemType : ' + elemType);
      }

      if (elem && elem.attributes) {
        setAttribute(currentNode, elem.attributes);
      }

      return currentNode;
    };

    var createNode = function (elem, parentNode) {
      //console.log('createNode invoked', elem, parentNode);
      var currentNode = makeCurrentNode(elem);
      //console.log('currentNode', currentNode);
      var childElems = elem.content;

      for (var idx in childElems) {
        createNode(childElems[idx], currentNode);
      }

      if (currentNode.tagName === 'SCRIPT' && !!currentNode.src) { // script
          if (!!currentNode.getAttributeNode('nomodule')) {
              // do nothing
          } else {
              scriptQueue.push({parentNode: parentNode, currentNode: currentNode});
          }
      } else {
          if (parentNode !== rootNode) {
            parentNode.appendChild(currentNode);
          }
      }
    };

    var appendScripts = function () {
      for (var i = 0; i < scriptQueue.length - 1; i++) {
        (function (idx) {
          scriptQueue[idx].currentNode.onload = function () {
            scriptQueue[idx + 1].parentNode.appendChild(scriptQueue[idx + 1].currentNode)
          };
        })(i);
      }
      if (scriptQueue[0]) {
        scriptQueue[0].parentNode.appendChild(scriptQueue[0].currentNode);
      }
    };

    createNode(map, rootNode);
    appendScripts();
  })(json, window);
}

function processUrl(url) {
    console.log('PageCall processUrl');

    // remove index screen
    cleanUpBodyAndHead();
    
    // decode html
    var rawHtml = url;
    //console.log('raw html', rawHtml);
    var decodedHtml = decodeURI(rawHtml);
    //console.log('decodedHtml', decodedHtml);
    var html = decodedHtml.replace(/\<!DOCTYPE.+?\>/g,'').replace(/\<!doctype.+?\>/g,'').trim();
    //console.log('retHtml', html);
    
    loadHtml(html);
}
