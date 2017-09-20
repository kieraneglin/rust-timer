extern crate qml;
use qml::*;

pub struct Timer {
    start_time: usize,
}
Q_OBJECT!{
    pub Timer as QTimer {
        signals:
        slots:
            fn start_timer();
        properties:
    }
}

impl QTimer {
    fn start_timer(&mut self) -> Option<&QVariant> {
        println!("HEY");
        None
    }
}

fn main() {
    let mut engine = QmlEngine::new();
    let timer = Timer { start_time: 100 };
    let q_timer = QTimer::new(timer);
    engine.set_and_store_property("timer", q_timer.get_qobj());

    engine.load_file("view/main.qml");
    engine.exec();
    engine.quit();
}
