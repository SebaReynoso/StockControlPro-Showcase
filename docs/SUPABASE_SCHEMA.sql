-- ====================================================================================
-- Arquitectura de Base de Datos - StockControl Pro
-- Diseñado por: Seba Reynoso (UniverseAI)
-- Desarrollado para el ecosistema de: LexinCorp
-- Objetivo: Garantizar integridad referencial, atomicidad de stock y Zero Trust RLS.
-- ====================================================================================

-- Habilitar extensión UUID (si no está habilitada por defecto en Supabase)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- TABLA: productos
-- ==========================================
CREATE TABLE IF NOT EXISTS public.productos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre TEXT NOT NULL,
    sku TEXT UNIQUE NOT NULL,
    codigo_barras TEXT, -- Opcional (DROP NOT NULL aplicado)
    categoria TEXT NOT NULL,
    cantidad INTEGER NOT NULL DEFAULT 0,
    costo DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ==========================================
-- TABLA: movimientos
-- ==========================================
CREATE TABLE IF NOT EXISTS public.movimientos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    producto_id UUID NOT NULL REFERENCES public.productos(id) ON DELETE CASCADE,
    tipo TEXT NOT NULL CHECK (tipo IN ('Entrada', 'Salida')),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    notas TEXT,
    usuario_id UUID REFERENCES auth.users(id), -- Auditoría por usuario
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL -- Tiempo oficial
);

-- ==========================================
-- FUNCIÓN / TRIGGER: Actualización automática de stock
-- ==========================================
-- Función que ejecutará el trigger de PostgreSQL para actualizar la cantidad del producto
CREATE OR REPLACE FUNCTION public.actualizar_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo = 'Entrada' THEN
        UPDATE public.productos
        SET cantidad = cantidad + NEW.cantidad
        WHERE id = NEW.producto_id;
    ELSIF NEW.tipo = 'Salida' THEN
        UPDATE public.productos
        SET cantidad = cantidad - NEW.cantidad
        WHERE id = NEW.producto_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger adjunto a la tabla movimientos que reacciona a los INSERT
DROP TRIGGER IF EXISTS trigger_actualizar_stock ON public.movimientos;
CREATE TRIGGER trigger_actualizar_stock
AFTER INSERT ON public.movimientos
FOR EACH ROW
EXECUTE FUNCTION public.actualizar_stock();

-- ==========================================
-- POLÍTICAS DE SEGURIDAD (Row Level Security - RLS)
-- ==========================================

-- Habilitar RLS en las tablas principales
ALTER TABLE public.productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.movimientos ENABLE ROW LEVEL SECURITY;

-- Políticas para que el historial e inventario sean legibles por usuarios autenticados
CREATE POLICY "Usuarios autenticados pueden ver productos"
ON public.productos FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Usuarios autenticados pueden ver movimientos"
ON public.movimientos FOR SELECT
TO authenticated
USING (true);

-- Políticas para permitir inserciones/modificaciones (requeridas para el funcionamiento de la app)
CREATE POLICY "Usuarios autenticados pueden insertar movimientos"
ON public.movimientos FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "Usuarios autenticados pueden insertar/actualizar productos"
ON public.productos FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);
