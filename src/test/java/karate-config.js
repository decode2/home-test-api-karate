function fn() {
  var env = karate.env; // get java system property 'karate.env'
  if (!env) {
    env = 'dev'; // default to dev
  }
  
  var config = {
    baseUrl: 'http://localhost:3100/api',
  }

  // Timeout configuration (optional but recommended)
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  return config;
}
  