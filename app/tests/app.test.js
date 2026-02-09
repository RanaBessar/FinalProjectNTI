const request = require('supertest');
const app = require('../server');

describe('Health Endpoints', () => {
  test('GET /health returns healthy status', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('healthy');
    expect(response.body).toHaveProperty('timestamp');
    expect(response.body).toHaveProperty('uptime');
  });

  test('GET /ready returns ready status', async () => {
    const response = await request(app).get('/ready');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('ready');
  });

  test('GET /live returns alive status', async () => {
    const response = await request(app).get('/live');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('alive');
  });
});

describe('API Endpoints', () => {
  test('GET / returns welcome message', async () => {
    const response = await request(app).get('/');
    expect(response.status).toBe(200);
    expect(response.body.name).toBe('NTI App');
    expect(response.body).toHaveProperty('version');
  });

  test('GET /api/info returns app info', async () => {
    const response = await request(app).get('/api/info');
    expect(response.status).toBe(200);
    expect(response.body.application).toBe('nti-app');
    expect(response.body).toHaveProperty('node_version');
  });

  test('GET /nonexistent returns 404', async () => {
    const response = await request(app).get('/nonexistent');
    expect(response.status).toBe(404);
    expect(response.body.error).toBe('Not Found');
  });
});
