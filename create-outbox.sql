CREATE TABLE outbox_event (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  aggregatetype VARCHAR(255) NOT NULL,
  aggregateid VARCHAR(255) NOT NULL,
  `type` VARCHAR(255) NOT NULL,
  payload TEXT
);
