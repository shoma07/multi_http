extern crate libc;
extern crate reqwest;
extern crate serde;
extern crate futures;

use libc::*;
use std::ffi::{CStr, CString};
use serde::{Deserialize, Serialize};
use serde_json::{from_str, to_string};
use futures::future::join_all;
use reqwest::{Client, Method};

#[derive(Deserialize)]
enum HttpMethod {
    GET,
    POST,
    PUT,
    PATCH,
    DELETE,
    HEAD
}

impl HttpMethod {
    fn to_method(&self) -> Method {
        match self {
            HttpMethod::GET => Method::GET,
            HttpMethod::POST => Method::POST,
            HttpMethod::PUT => Method::PUT,
            HttpMethod::PATCH => Method::PATCH,
            HttpMethod::DELETE => Method::DELETE,
            HttpMethod::HEAD => Method::HEAD
        }
    }
}

#[derive(Deserialize)]
struct RequestList {
    requests: Vec<Request>,
}

#[derive(Deserialize)]
struct Request {
    method: HttpMethod,
    uri: String,
    body: String,
}

#[derive(Serialize)]
struct ResponseList {
  responses: Vec<Response>,
}

#[derive(Serialize)]
struct Response {
    status: u16,
    body: String,
}

#[tokio::main]
#[no_mangle]
pub async extern fn multi_http(json: *const c_char) -> *const c_char {
    CString::new(to_string(&ResponseList{
        responses: join_all(
            from_str::<RequestList>(
                unsafe { CStr::from_ptr(json) }.to_str().unwrap()
            ).unwrap().requests.iter().map(|request| { async move {
                let resp = Client::new().request(
                    request.method.to_method(), &request.uri
                ).body(String::from(&request.body)).send().await.unwrap();
                Response{
                    status: resp.status().as_u16(),
                    body: resp.text().await.unwrap()
                }
            }})
        ).await
    }).unwrap()).unwrap().into_raw()
}
