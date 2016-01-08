var Sails = require('sails'),
  sails;

var assert = require('assert');
var request = require('supertest');

before(function(done) {
  
  this.timeout(9000);
  
  Sails.lift({

    log: {
      level: 'error'
    },

    adapters: {
      mongo: {
        module: 'sails-mongo',
        host: 'localhost',
        database: 'proxyapp',
        user: 'proxyapprw',
        pass: 'pass1234'
      }
    }

  }, function(err, sails) {
    app = sails;
    done(err, sails);
  });
  
});

describe('Basic', function(done) {
  it("should cause ok", function(done) {
    assert.equal(1, 1, "ok");
    done();
  });
});

describe('Routes', function(done) {
  it('GET / should return 200', function (done) {
    //request(Sails.hooks.http.app).get('/api/apps').expect(200, done);
    request(Sails.hooks.http.app).get('/').expect(200, done);
  });
});


after(function(done) {
  Sails.lower(done);
});

