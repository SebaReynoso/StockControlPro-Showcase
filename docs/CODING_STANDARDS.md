Estándares de Código y Mejores Prácticas — LexinCorp 🛠️
Este documento define las convenciones y estándares técnicos aplicados en el desarrollo de StockControl Pro para garantizar un código limpio, mantenible y profesional.

1. Arquitectura y Estructura
Componentes Funcionales: En el frontend (React + Vite), se utilizan exclusivamente componentes funcionales con Hooks para una lógica más clara y reutilizable.

Separación de Responsabilidades: Se mantiene una división estricta entre la lógica de negocio, el acceso a datos (Supabase) y la capa de presentación (Tailwind CSS).

Patrón de Carpetas: La estructura sigue un orden lógico: /components para UI, /hooks para lógica compartida y /services para la comunicación con el backend.

2. Convenciones de Nomenclatura
Variables y Funciones: Se utiliza camelCase para todas las variables y funciones (ej: getInventoryData).

Componentes: Los archivos y funciones de componentes de React utilizan PascalCase (ej: InventoryCard.jsx).

Base de Datos: Las tablas y columnas en PostgreSQL (Supabase) se definen en snake_case por estándar de industria.

3. Estilos y Diseño (Tailwind CSS)
Utility-First: Se prioriza el uso de clases de Tailwind para mantener la consistencia visual sin archivos CSS externos innecesarios.

Responsividad: Todo desarrollo debe ser "Mobile-First", asegurando que la experiencia en iPhone sea tan fluida como en Desktop.

Design System: Se utilizan variables de color y espaciado predefinidas para mantener la identidad visual de LexinCorp.

4. Gestión de Datos y Seguridad (Supabase)
Zero Trust con RLS: No se confía en la seguridad del lado del cliente; todas las restricciones de acceso se ejecutan mediante políticas de Row Level Security en la base de datos.

Manejo de Estados: Se utiliza el estado de React y la suscripción en tiempo real de Supabase para asegurar que el inventario esté siempre actualizado.

Validación: Cada entrada de datos pasa por una capa de validación antes de ser enviada a la base de datos para prevenir errores de integridad.

5. Control de Versiones (Git)
Commits Semánticos: Los mensajes de commit deben ser claros y descriptivos (ej: feat: add PDF report generation, fix: camera scanner latency).

Branches: El desarrollo se realiza en ramas de funcionalidad antes de integrarse a la rama principal para asegurar la estabilidad del producto.

Documento de uso interno en UniverseAI / LexinCorp

Responsable: Seba Reynoso — Lead Fullstack Developer