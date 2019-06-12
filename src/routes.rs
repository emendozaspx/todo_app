use crate::models::Todo;
use crate::schema::todos;
use crate::TodoDatabase;
use diesel::prelude::*;
use rocket_contrib::json::{Json, JsonValue};

#[post("/todo", format = "json", data = "<todo>")]
pub fn create_todo(todo: Json<Todo>, conn: TodoDatabase) {
    diesel::insert_into(todos::table)
        .values(&todo.0)
        .execute(&*conn)
        .expect("Error creating new todo");
}

#[get("/todos")]
pub fn read_todos(conn: TodoDatabase) -> Json<Vec<Todo>> {
    let results = todos::table
        .load::<Todo>(&*conn)
        .expect("Error reading todos");

    Json(results)
}

#[put("/todo/<id>", format = "json", data = "<todo>")]
pub fn update_todo(id: i32, todo: Json<Todo>, conn: TodoDatabase) -> JsonValue {
    let success = diesel::update(todos::dsl::todos.find(id))
        .set(&todo.0)
        .execute(&*conn)
        .is_ok();

    json!({ "success": success })
}

#[delete("/todo/<id>")]
pub fn delete_todo(id: i32, conn: TodoDatabase) -> JsonValue {
    let success = diesel::delete(todos::dsl::todos.find(id))
        .execute(&*conn)
        .is_ok();

    json!({ "success": success })
}
