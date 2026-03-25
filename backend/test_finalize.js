async function testFinalize() {
  try {
    // 1. Login
    const loginRes = await fetch('http://localhost:3000/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: 'operador@gmail.com',
        password: 'Admin123'
      })
    });
    
    if (!loginRes.ok) throw new Error(`Login failed: ${loginRes.status}`);
    const loginData = await loginRes.json();
    const token = loginData.access_token;
    console.log('Login successful.');

    // 2. Get active alerts
    const alertsRes = await fetch('http://localhost:3000/alerts/active', {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    
    const alerts = await alertsRes.json();
    if (alerts.length === 0) {
      console.log('No active alerts to finalize.');
      return;
    }
    
    const alertId = alerts[0].id;
    console.log(`Attempting to finalize alert: ${alertId}`);

    // 3. Finalize alert
    const finalizeRes = await fetch(`http://localhost:3000/alerts/${alertId}/finalize`, {
      method: 'PATCH',
      headers: { 
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ report: 'Test report from script' })
    });

    const finalizeData = await finalizeRes.json();
    if (!finalizeRes.ok) {
      console.error('Error Response:', finalizeRes.status, finalizeData);
    } else {
      console.log('Finalize successful:', finalizeData);
    }
  } catch (error) {
    console.error('Network Error:', error.message);
  }
}

testFinalize();
