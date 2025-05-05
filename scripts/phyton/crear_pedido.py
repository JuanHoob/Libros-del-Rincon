import mysql.connector

def crear_pedido(id_cliente, id_libro, cantidad):
    db = mysql.connector.connect(user='TU_USUARIO', password='TU_CONTRASEÑA', 
                                 host='localhost', database='libros_rincon')
    cursor = db.cursor()

    # Insertar registro en Pedidos con fecha actual y calcular monto total
    cursor.execute(
        "INSERT INTO Pedidos (id_cliente, fecha_pedido, monto_total) VALUES (%s, CURDATE(), %s)",
        (id_cliente, cantidad * obtener_precio(id_libro, cursor))
    )
    pedido_id = cursor.lastrowid

    # Obtener precio unitario del libro y registrar en Items_Pedido
    precio = obtener_precio(id_libro, cursor)
    cursor.execute(
        "INSERT INTO Items_Pedido VALUES (%s, %s, %s, %s)",
        (pedido_id, id_libro, cantidad, precio)
    )

    db.commit()
    cursor.close()
    db.close()

def obtener_precio(id_libro, cursor):
    cursor.execute("SELECT precio FROM Libros WHERE id_libro=%s", (id_libro,))
    return cursor.fetchone()[0]
