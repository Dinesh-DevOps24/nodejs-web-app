import express from "express";
import path from "path";
import { fileURLToPath } from "url";
import ejs from "ejs";
import cors from "cors";
import helmet from "helmet";

import routes from "./routes/index.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = 8000;

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));
app.engine("html", ejs.renderFile);

app.use(express.static(path.join(__dirname, "public")));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(helmet());

app.use(
  cors({
    origin: (origin, cb) => cb(null, true),
    credentials: true,
  })
);

routes(app);

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server listening on ${PORT}`);
});

export default app;