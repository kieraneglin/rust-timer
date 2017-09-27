extern crate chrono;
extern crate qml;

use std::fs::File;
use std::io::prelude::*;
use chrono::prelude::*;
use qml::*;

pub struct Timer {
    start_time: Option<DateTime<Utc>>,
    end_time: Option<DateTime<Utc>>,
    history: Vec<[String; 2]>,
}

Q_OBJECT!{
    pub Timer as QTimer {
        signals:
        slots:
            fn start_timer();
            fn end_timer(colors: String);
            fn write_history();
        properties:
    }
}

impl QTimer {
    fn start_timer(&mut self) -> Option<&QVariant> {
        self.start_time = Some(Utc::now());
        None
    }

    fn end_timer(&mut self, colors: String) -> Option<&QVariant> {
        self.end_time = Some(Utc::now());

        match self.start_time {
            Some(start) => {
                let difference = self.end_time.unwrap().signed_duration_since(start);
                let time = difference.num_milliseconds().to_string();

                self.history.push([time, colors]);
            }
            None => unreachable!(),
        };

        None
    }

    fn write_history(&mut self) -> Option<&QVariant> {
        let filename = Utc::now().timestamp().to_string() + ".txt";
        let mut file = File::create(filename).unwrap();
        let mut contents: Vec<String> = vec!["time, actual, choice".to_owned()];

        for entry in self.history.iter() {
            contents.push(entry.join(", "));
        }

        file.write_all(contents.join("\n").as_bytes()).unwrap();

        None
    }
}

fn main() {
    let mut engine = QmlEngine::new();
    let timer = Timer {
        start_time: None,
        end_time: None,
        history: vec![],
    };
    let mut q_timer = QTimer::new(timer);

    engine.set_and_store_property("timer", q_timer.get_qobj());

    engine.load_data(include_str!("view/main.qml"));
    engine.exec();
    engine.quit();

    q_timer.write_history();
}
