// Utilidades para base de datos SQLite - AnuSet Desktop
// Versión optimizada para funcionamiento offline

import fs from 'fs';
import path from 'path';
import { promisify } from 'util';

// Importar SQLite3 de forma compatible con Vite
let sqlite3;
try {
  sqlite3 = require('sqlite3').verbose();
} catch (error) {
  console.warn('SQLite3 no disponible, usando configuración por defecto');
  sqlite3 = null;
}

// Configuración de base de datos
const DB_CONFIG = {
  path: 'config/database.sqlite',
  backupDir: 'config/backups',
  migrationsDir: 'config/migrations'
};

// Clase para manejo de base de datos
class Database {
  constructor() {
    this.db = null;
    this.isConnected = false;
  }

  // Conectar a la base de datos
  async connect() {
    if (!sqlite3) {
      console.warn('SQLite3 no disponible, usando almacenamiento en memoria');
      this.inMemoryDb = new Map();
      return;
    }

    return new Promise((resolve, reject) => {
      try {
        // Crear directorio si no existe
        const dbDir = path.dirname(DB_CONFIG.path);
        if (!fs.existsSync(dbDir)) {
          fs.mkdirSync(dbDir, { recursive: true });
        }

        // Conectar a la base de datos
        this.db = new sqlite3.Database(DB_CONFIG.path, (err) => {
          if (err) {
            console.error('Error conectando a la base de datos:', err);
            reject(err);
          } else {
            console.log('✅ Base de datos SQLite conectada');
            this.isConnected = true;
            this.runMigrations().then(resolve).catch(reject);
          }
        });
      } catch (error) {
        console.error('Error inicializando base de datos:', error);
        reject(error);
      }
    });
  }

  // Ejecutar migraciones iniciales
  async runMigrations() {
    if (!this.db) return;

    const migrations = [
      // Tabla de usuarios
      `CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password_hash TEXT,
        email TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        last_login DATETIME,
        settings TEXT DEFAULT '{}'
      )`,
      
      // Tabla de conversaciones
      `CREATE TABLE IF NOT EXISTS conversations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        message TEXT NOT NULL,
        response TEXT,
        personality TEXT DEFAULT 'default',
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )`,
      
      // Tabla de configuraciones
      `CREATE TABLE IF NOT EXISTS settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        key TEXT NOT NULL,
        value TEXT,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id),
        UNIQUE(user_id, key)
      )`,
      
      // Tabla de configuraciones de avatar
      `CREATE TABLE IF NOT EXISTS avatar_configs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        model_path TEXT,
        expressions TEXT,
        animations TEXT,
        lighting TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )`
    ];

    for (const migration of migrations) {
      await this.run(migration);
    }

    // Crear usuario por defecto
    await this.createDefaultUser();
  }

  // Crear usuario por defecto
  async createDefaultUser() {
    const user = await this.get('users', { username: 'kali' });
    if (!user) {
      await this.run(
        'INSERT INTO users (username, password_hash, email, settings) VALUES (?, ?, ?, ?)',
        ['kali', 'kali', 'kali@anuset.local', JSON.stringify({ theme: 'dark', language: 'es' })]
      );
      console.log('👤 Usuario por defecto creado: kali');
    }
  }

  // Ejecutar query
  run(sql, params = []) {
    if (!this.db) {
      return Promise.resolve();
    }

    return new Promise((resolve, reject) => {
      this.db.run(sql, params, function(err) {
        if (err) {
          reject(err);
        } else {
          resolve({ id: this.lastID, changes: this.changes });
        }
      });
    });
  }

  // Obtener un registro
  get(table, conditions = {}) {
    if (!this.db) {
      return Promise.resolve(null);
    }

    const keys = Object.keys(conditions);
    const values = Object.values(conditions);
    
    if (keys.length === 0) {
      return Promise.resolve(null);
    }

    const whereClause = keys.map(key => `${key} = ?`).join(' AND ');
    const sql = `SELECT * FROM ${table} WHERE ${whereClause} LIMIT 1`;

    return new Promise((resolve, reject) => {
      this.db.get(sql, values, (err, row) => {
        if (err) {
          reject(err);
        } else {
          resolve(row);
        }
      });
    });
  }

  // Obtener múltiples registros
  all(table, conditions = {}, options = {}) {
    if (!this.db) {
      return Promise.resolve([]);
    }

    const keys = Object.keys(conditions);
    const values = Object.values(conditions);
    
    let sql = `SELECT * FROM ${table}`;
    let params = [...values];

    if (keys.length > 0) {
      const whereClause = keys.map(key => `${key} = ?`).join(' AND ');
      sql += ` WHERE ${whereClause}`;
    }

    if (options.orderBy) {
      sql += ` ORDER BY ${options.orderBy}`;
    }

    if (options.limit) {
      sql += ` LIMIT ${options.limit}`;
      if (options.offset) {
        sql += ` OFFSET ${options.offset}`;
      }
    }

    return new Promise((resolve, reject) => {
      this.db.all(sql, params, (err, rows) => {
        if (err) {
          reject(err);
        } else {
          resolve(rows);
        }
      });
    });
  }

  // Insertar registro
  insert(table, data) {
    if (!this.db) {
      return Promise.resolve({ id: Date.now() });
    }

    const keys = Object.keys(data);
    const values = Object.values(data);
    const placeholders = keys.map(() => '?').join(', ');
    const columns = keys.join(', ');

    const sql = `INSERT INTO ${table} (${columns}) VALUES (${placeholders})`;

    return this.run(sql, values);
  }

  // Actualizar registro
  update(table, data, conditions) {
    if (!this.db) {
      return Promise.resolve({ changes: 0 });
    }

    const dataKeys = Object.keys(data);
    const dataValues = Object.values(data);
    const conditionKeys = Object.keys(conditions);
    const conditionValues = Object.values(conditions);

    const setClause = dataKeys.map(key => `${key} = ?`).join(', ');
    const whereClause = conditionKeys.map(key => `${key} = ?`).join(' AND ');

    const sql = `UPDATE ${table} SET ${setClause} WHERE ${whereClause}`;
    const params = [...dataValues, ...conditionValues];

    return this.run(sql, params);
  }

  // Eliminar registro
  delete(table, conditions) {
    if (!this.db) {
      return Promise.resolve({ changes: 0 });
    }

    const keys = Object.keys(conditions);
    const values = Object.values(conditions);
    const whereClause = keys.map(key => `${key} = ?`).join(' AND ');

    const sql = `DELETE FROM ${table} WHERE ${whereClause}`;

    return this.run(sql, values);
  }

  // Crear backup
  async createBackup() {
    if (!this.db) return;

    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const backupPath = path.join(path.dirname(DB_CONFIG.path), 'backups', `database-${timestamp}.sqlite`);

    try {
      // Crear directorio de backups
      const backupDir = path.dirname(backupPath);
      if (!fs.existsSync(backupDir)) {
        fs.mkdirSync(backupDir, { recursive: true });
      }

      // Copiar base de datos
      fs.copyFileSync(DB_CONFIG.path, backupPath);
      console.log(`💾 Backup creado: ${backupPath}`);

      return backupPath;
    } catch (error) {
      console.error('Error creando backup:', error);
      throw error;
    }
  }

  // Cerrar conexión
  close() {
    if (this.db) {
      return new Promise((resolve) => {
        this.db.close((err) => {
          if (err) {
            console.error('Error cerrando base de datos:', err);
          } else {
            console.log('🔒 Base de datos cerrada');
          }
          this.isConnected = false;
          resolve();
        });
      });
    }
  }
}

// Instancia global de base de datos
let database = null;

// Función para obtener la instancia de base de datos
export const getDatabase = () => {
  if (!database) {
    database = new Database();
  }
  return database;
};

// Función para inicializar la base de datos
export const setupDatabase = async () => {
  const db = getDatabase();
  await db.connect();
  return db;
};

// Funciones de conveniencia
export const db = {
  // Usuarios
  async getUser(username) {
    const database = getDatabase();
    return await database.get('users', { username });
  },

  async createUser(userData) {
    const database = getDatabase();
    return await database.insert('users', userData);
  },

  // Conversaciones
  async getConversations(userId, limit = 50) {
    const database = getDatabase();
    return await database.all('conversations', { user_id: userId }, { 
      orderBy: 'timestamp DESC', 
      limit 
    });
  },

  async saveConversation(conversation) {
    const database = getDatabase();
    return await database.insert('conversations', conversation);
  },

  // Configuraciones
  async getSetting(userId, key) {
    const database = getDatabase();
    const setting = await database.get('settings', { user_id: userId, key });
    return setting ? JSON.parse(setting.value) : null;
  },

  async setSetting(userId, key, value) {
    const database = getDatabase();
    const settingData = {
      user_id: userId,
      key,
      value: JSON.stringify(value)
    };
    return await database.upsert('settings', settingData, { user_id: userId, key });
  },

  // Configuraciones de avatar
  async getAvatarConfig(userId) {
    const database = getDatabase();
    const config = await database.get('avatar_configs', { user_id: userId });
    if (config) {
      return {
        ...config,
        expressions: JSON.parse(config.expressions || '{}'),
        animations: JSON.parse(config.animations || '{}'),
        lighting: JSON.parse(config.lighting || '{}')
      };
    }
    return null;
  },

  async saveAvatarConfig(userId, config) {
    const database = getDatabase();
    const configData = {
      user_id: userId,
      model_path: config.model_path,
      expressions: JSON.stringify(config.expressions || {}),
      animations: JSON.stringify(config.animations || {}),
      lighting: JSON.stringify(config.lighting || {})
    };
    return await database.upsert('avatar_configs', configData, { user_id: userId });
  }
};

export default Database;