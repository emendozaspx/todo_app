use crate::schema::todos;

#[derive(Serialize, Deserialize, Queryable, Insertable, AsChangeset)]
#[table_name="todos"]
pub struct Todo {
    pub id: Option<i32>,
    pub title: String,
    pub body: String,
}