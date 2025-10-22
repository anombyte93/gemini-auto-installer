#!/usr/bin/env node

/**
 * Instructor Dashboard - Web interface for viewing student SSH connections
 * Runs a simple web server that displays registered students and their connection info
 */

const http = require('http');
const fs = require('fs');
const path = require('path');
const os = require('os');

const PORT = process.env.DASHBOARD_PORT || 8080;
const DATA_DIR = path.join(os.homedir(), '.instructor-dashboard');
const STUDENTS_FILE = path.join(DATA_DIR, 'students.json');

// Ensure data directory exists
if (!fs.existsSync(DATA_DIR)) {
    fs.mkdirSync(DATA_DIR, { recursive: true });
}

// Initialize students file if it doesn't exist
if (!fs.existsSync(STUDENTS_FILE)) {
    fs.writeFileSync(STUDENTS_FILE, JSON.stringify([]), 'utf8');
}

// Helper: Read students from file
function getStudents() {
    try {
        const data = fs.readFileSync(STUDENTS_FILE, 'utf8');
        return JSON.parse(data);
    } catch (error) {
        console.error('Error reading students file:', error);
        return [];
    }
}

// Helper: Save students to file
function saveStudents(students) {
    try {
        fs.writeFileSync(STUDENTS_FILE, JSON.stringify(students, null, 2), 'utf8');
        return true;
    } catch (error) {
        console.error('Error saving students file:', error);
        return false;
    }
}

// Helper: Check if student is reachable
function checkStudentStatus(student, callback) {
    const { exec } = require('child_process');
    const timeout = 2000; // 2 seconds

    exec(`timeout 2 nc -zv ${student.ip} ${student.port} 2>&1`, (error, stdout, stderr) => {
        const output = stdout + stderr;
        const isOnline = output.includes('succeeded') || output.includes('open');
        callback(isOnline);
    });
}

// HTML template for dashboard
function getDashboardHTML(students) {
    const studentRows = students.map((student, index) => {
        const lastSeen = student.lastSeen ? new Date(student.lastSeen).toLocaleString() : 'Never';
        const statusBadge = student.online
            ? '<span class="badge online">🟢 Online</span>'
            : '<span class="badge offline">🔴 Offline</span>';

        return `
            <tr>
                <td>${index + 1}</td>
                <td><strong>${student.name}</strong></td>
                <td>${student.ip}</td>
                <td>${student.port}</td>
                <td>${student.username}</td>
                <td>${statusBadge}</td>
                <td>${lastSeen}</td>
                <td>
                    <code class="ssh-command" onclick="copyToClipboard('ssh ${student.username}@${student.ip}')">
                        ssh ${student.username}@${student.ip}
                    </code>
                    ${student.port !== '22' ? `<br><code class="ssh-command" onclick="copyToClipboard('ssh -p ${student.port} ${student.username}@${student.ip}')">ssh -p ${student.port} ${student.username}@${student.ip}</code>` : ''}
                </td>
            </tr>
        `;
    }).join('');

    return `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instructor Dashboard - Student SSH Connections</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .header h1 {
            font-size: 2em;
            margin-bottom: 10px;
        }

        .header p {
            opacity: 0.9;
            font-size: 1.1em;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 30px;
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }

        .stat-card .number {
            font-size: 2.5em;
            font-weight: bold;
            color: #667eea;
        }

        .stat-card .label {
            color: #6c757d;
            margin-top: 5px;
        }

        .content {
            padding: 30px;
        }

        .controls {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1em;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }

        thead {
            background: #f8f9fa;
        }

        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
        }

        .badge.online {
            background: #d4edda;
            color: #155724;
        }

        .badge.offline {
            background: #f8d7da;
            color: #721c24;
        }

        .ssh-command {
            background: #f1f3f5;
            padding: 8px 12px;
            border-radius: 6px;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            display: inline-block;
            cursor: pointer;
            transition: all 0.2s;
        }

        .ssh-command:hover {
            background: #e9ecef;
            transform: scale(1.02);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .empty-state img {
            width: 200px;
            opacity: 0.5;
            margin-bottom: 20px;
        }

        .empty-state h2 {
            margin-bottom: 10px;
        }

        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            background: #28a745;
            color: white;
            padding: 15px 25px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            display: none;
            animation: slideIn 0.3s ease;
        }

        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        .footer {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #6c757d;
            border-top: 1px solid #dee2e6;
        }

        @media (max-width: 768px) {
            table {
                font-size: 0.9em;
            }

            .ssh-command {
                font-size: 0.8em;
                padding: 6px 10px;
            }
        }
    </style>
</head>
<body>
    <div id="notification" class="notification"></div>

    <div class="container">
        <div class="header">
            <h1>🎓 Instructor Dashboard</h1>
            <p>Monitor and connect to student machines</p>
        </div>

        <div class="stats">
            <div class="stat-card">
                <div class="number">${students.length}</div>
                <div class="label">Total Students</div>
            </div>
            <div class="stat-card">
                <div class="number">${students.filter(s => s.online).length}</div>
                <div class="label">Online Now</div>
            </div>
            <div class="stat-card">
                <div class="number">${students.filter(s => !s.online).length}</div>
                <div class="label">Offline</div>
            </div>
        </div>

        <div class="content">
            <div class="controls">
                <button class="btn btn-primary" onclick="refreshPage()">🔄 Refresh</button>
                <button class="btn btn-danger" onclick="clearAllStudents()">🗑️ Clear All</button>
            </div>

            ${students.length > 0 ? `
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Student Name</th>
                            <th>IP Address</th>
                            <th>Port</th>
                            <th>Username</th>
                            <th>Status</th>
                            <th>Last Seen</th>
                            <th>SSH Command</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${studentRows}
                    </tbody>
                </table>
            ` : `
                <div class="empty-state">
                    <h2>No Students Registered Yet</h2>
                    <p>Students will appear here once they run the setup-instructor-access.sh script</p>
                    <br>
                    <p><strong>Setup URL:</strong> http://${getLocalIP()}:${PORT}/register</p>
                </div>
            `}
        </div>

        <div class="footer">
            <p>Dashboard running on http://${getLocalIP()}:${PORT}</p>
            <p style="margin-top: 10px; font-size: 0.9em;">Auto-refresh every 30 seconds</p>
        </div>
    </div>

    <script>
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text).then(() => {
                showNotification('Copied to clipboard: ' + text);
            });
        }

        function showNotification(message) {
            const notif = document.getElementById('notification');
            notif.textContent = message;
            notif.style.display = 'block';
            setTimeout(() => {
                notif.style.display = 'none';
            }, 3000);
        }

        function refreshPage() {
            location.reload();
        }

        function clearAllStudents() {
            if (confirm('Are you sure you want to remove all students?')) {
                fetch('/api/clear', { method: 'POST' })
                    .then(() => location.reload());
            }
        }

        // Auto-refresh every 30 seconds
        setTimeout(() => location.reload(), 30000);
    </script>
</body>
</html>
    `;
}

// Get local IP address
function getLocalIP() {
    const interfaces = os.networkInterfaces();
    for (const name of Object.keys(interfaces)) {
        for (const iface of interfaces[name]) {
            if (iface.family === 'IPv4' && !iface.internal) {
                return iface.address;
            }
        }
    }
    return 'localhost';
}

// API: Register student
function registerStudent(req, res) {
    let body = '';
    req.on('data', chunk => body += chunk.toString());
    req.on('end', () => {
        try {
            const data = JSON.parse(body);
            const students = getStudents();

            // Check if student already exists (by IP)
            const existingIndex = students.findIndex(s => s.ip === data.ip);

            const studentData = {
                name: data.name,
                ip: data.ip,
                port: data.port || '22',
                username: data.username,
                lastSeen: new Date().toISOString(),
                online: true
            };

            if (existingIndex >= 0) {
                students[existingIndex] = studentData;
            } else {
                students.push(studentData);
            }

            saveStudents(students);

            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ success: true, message: 'Student registered' }));
        } catch (error) {
            res.writeHead(400, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ success: false, error: error.message }));
        }
    });
}

// API: Clear all students
function clearStudents(req, res) {
    saveStudents([]);
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ success: true }));
}

// Create HTTP server
const server = http.createServer((req, res) => {
    if (req.method === 'GET' && req.url === '/') {
        // Update student statuses before displaying
        const students = getStudents();
        let checkedCount = 0;

        if (students.length === 0) {
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(getDashboardHTML(students));
            return;
        }

        students.forEach((student, index) => {
            checkStudentStatus(student, (isOnline) => {
                students[index].online = isOnline;
                if (isOnline) {
                    students[index].lastSeen = new Date().toISOString();
                }
                checkedCount++;

                if (checkedCount === students.length) {
                    saveStudents(students);
                    res.writeHead(200, { 'Content-Type': 'text/html' });
                    res.end(getDashboardHTML(students));
                }
            });
        });
    } else if (req.method === 'POST' && req.url === '/api/register') {
        registerStudent(req, res);
    } else if (req.method === 'POST' && req.url === '/api/clear') {
        clearStudents(req, res);
    } else {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('Not Found');
    }
});

// Start server
server.listen(PORT, '0.0.0.0', () => {
    console.log('\n╔════════════════════════════════════════════════════════╗');
    console.log('║        🎓 Instructor Dashboard Started                ║');
    console.log('╚════════════════════════════════════════════════════════╝\n');
    console.log(`  📡 Dashboard URL: http://${getLocalIP()}:${PORT}`);
    console.log(`  🔗 Local access:  http://localhost:${PORT}`);
    console.log('\n  📊 Students will appear as they register');
    console.log('  🔄 Auto-refresh every 30 seconds');
    console.log('  📋 Click any SSH command to copy to clipboard\n');
    console.log('  Press Ctrl+C to stop the dashboard\n');
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\n\n🛑 Shutting down dashboard...');
    server.close(() => {
        console.log('✓ Dashboard stopped\n');
        process.exit(0);
    });
});
