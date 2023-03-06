'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "favicon.png": "5dcef449791fa27946b3d35ad8803796",
"manifest.json": "7d3a68ad4e32b653c455694bfbd80c46",
"version.json": "42889ce18f585677dbded7b1c3ffaa10",
"firebase-messaging-sw.js": "d41d8cd98f00b204e9800998ecf8427e",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"assets/env": "d2b7829ef9483336a4863c30cc629296",
"assets/FontManifest.json": "7970192b6ab6c5b68ec48eb7e3af221b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/assets/i18n/en_US.json": "f4f0158573b869afadcec976279e6232",
"assets/assets/i18n/es_CO.json": "81080fc99c9628137b8bcda64dff36e3",
"assets/assets/i18n/es_PE.json": "4b02bd205f5ed2a5340880d3bf611dec",
"assets/assets/i18n/es_CL.json": "2bbadda78d62fca5531a51ee01719304",
"assets/assets/images/empty_image.svg": "45d9571aa0393cf9379e89b97d419aa1",
"assets/assets/images/ilustracion-documentos.png": "fba7f56725748f609ae290e11e157bd9",
"assets/assets/images/check.svg": "27fc961f1cdfe219660445b19768e6ee",
"assets/assets/images/ilustracion-pagos.png": "4ae3fce177d4635391e96e671657d480",
"assets/assets/images/LOGO-iclavis.svg": "4f3900e4fa33e3293ab2ece163ea19d6",
"assets/assets/images/ilustracion-fotos.png": "c494b78dfa1c8be03e71e916cf29e592",
"assets/assets/images/i-propiedades.svg": "8293ebd31a63457dc974e895d3005238",
"assets/assets/images/question_card.svg": "e7af4433dddafb1da099cf3ab947e7b0",
"assets/assets/images/default_profile_image.png": "ccbbc35e2ceeabf54bad2d2211f51f43",
"assets/assets/images/request_card.svg": "828a76aa0bf5767c8efdbb21555ed76b",
"assets/assets/images/tips_para_compra.png": "e22ed79275826138198403aec125f619",
"assets/assets/images/LOGO-iclavis.png": "59d75e2621f83051e6c0677d2e212e1e",
"assets/assets/images/alert_contact_form.png": "fdb7b254f797921bc0d0f62df0e0ab48",
"assets/assets/images/ilustracion-soporte.png": "be2d1d1724727e2c2f682e3824bb001a",
"assets/assets/images/tips_card.svg": "614e7918024d51f7ccd6d68bbbed3fc4",
"assets/assets/images/default_profile_image.svg": "afa683412f55a795de6f8275f6142916",
"assets/assets/animations/wait_animation.riv": "2d4cecb24912729d2e88ff0758882351",
"assets/assets/animations/new_splashscreen-iclavis-l.riv": "9b6d09537476cd93cf1ad7e3fa72f323",
"assets/assets/animations/splashscreen-sinlogo.riv": "f65699c07e6d0c853059a3c3fe104388",
"assets/assets/icons/custom.ttf": "ce34bad13610f648d8ab0ee404d3012c",
"assets/assets/icons/faqsIcon.ttf": "2f655b9856d2f6b99fc27501e0cd883e",
"assets/NOTICES": "dd61bb48462d31d2e8c7746040619f36",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/AssetManifest.json": "5b4a6110f0799f8797eff4191dfdd2a6",
"index.html": "b43ba2ef60ccba0af2e696ecd93fc648",
"/": "b43ba2ef60ccba0af2e696ecd93fc648",
"main.dart.js": "c1335d6e6392d843a8ef6c4cc5344588",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
