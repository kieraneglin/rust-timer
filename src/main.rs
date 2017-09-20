extern crate chrono;
extern crate qml;

use chrono::prelude::*;
use chrono::Duration;
use qml::*;

pub struct Timer {
    start_time: Option<DateTime<Utc>>,
    end_time: Option<DateTime<Utc>>,
    times: Vec<Duration>,
}

Q_OBJECT!{
    pub Timer as QTimer {
        signals:
        slots:
            fn start_timer();
            fn end_timer();
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
                self.times.push(difference);

                println!("{:?}", self.times);
            }
            None => unreachable!(),
        };

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
    let q_timer = QTimer::new(timer);

    engine.set_and_store_property("timer", q_timer.get_qobj());

    engine.load_file("view/main.qml");
    engine.exec();
    engine.quit();
}
