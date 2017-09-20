extern crate chrono;
extern crate qml;

use std::fs::File;
use std::io::prelude::*;
use chrono::prelude::*;
use qml::*;

pub struct Timer {
    start_time: Option<DateTime<Utc>>,
    end_time: Option<DateTime<Utc>>,
    times: Vec<String>,
}

Q_OBJECT!{
    pub Timer as QTimer {
        signals:
        slots:
            fn start_timer();
            fn end_timer();
            fn write_times();
        properties:
    }
}

impl QTimer {
    fn start_timer(&mut self) -> Option<&QVariant> {
        self.start_time = Some(Utc::now());
        None
    }

    fn end_timer(&mut self) -> Option<&QVariant> {
        self.end_time = Some(Utc::now());

        match self.start_time {
            Some(start) => {
                let difference = self.end_time.unwrap().signed_duration_since(start);
                self.times.push(difference.num_milliseconds().to_string());
            }
            None => unreachable!(),
        };

        None
    }

    fn write_times(&mut self) -> Option<&QVariant> {
        let mut file = File::create("times.txt").unwrap();
        let contents = self.times.join("\n");

        file.write_all(contents.as_bytes()).unwrap();

        None
    }
}

fn main() {
    let mut engine = QmlEngine::new();
    let timer = Timer {
        start_time: None,
        end_time: None,
        times: vec![],
    };
    let mut q_timer = QTimer::new(timer);

    engine.set_and_store_property("timer", q_timer.get_qobj());

    engine.load_file("view/main.qml");
    engine.exec();
    engine.quit();

    q_timer.write_times();
}
