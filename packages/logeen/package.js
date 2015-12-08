Package.describe({
  name: 'oako:logeen',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: 'Simple authentification library with login and signup pages',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');
  api.use(['ecmascript', 'check', 'accounts-password', 'templating'], 'client');
  api.addFiles([
      'lib/logeen.js',
  ], ['client', 'server']);

  api.addFiles([
      'logeen_page.html',

      'logeen_page.js',
  ], 'client');

  api.export('Logeen', ['client', 'server']);
});

Package.onTest(function(api) {
  api.use('ecmascript');
  api.use('tinytest');
  api.use('oako:logeen');
  api.addFiles('logeen-tests.js');
});
