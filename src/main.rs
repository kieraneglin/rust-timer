extern crate qml;
use qml::*;

fn main() {
    let mut qqae = QmlEngine::new();

    qqae.load_file("src/view/main.qml");
    qqae.exec();
    qqae.quit();
}
