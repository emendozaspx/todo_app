#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;
#[macro_use]
extern crate rocket_contrib;
#[macro_use]
extern crate diesel;
#[macro_use]
extern crate serde_derive;
extern crate dotenv;

mod models;
mod routes;
mod schema;

use dotenv::dotenv;

#[database("todo_db")]
pub struct TodoDatabase(diesel::SqliteConnection);

fn main() {
    dotenv().ok();

    rocket::ignite()
        .attach(TodoDatabase::fairing())
        .mount(
            "/api",
            routes![
                routes::create_todo,
                routes::read_todos,
                routes::update_todo,
                routes::delete_todo
            ],
        )
        .launch();
}
