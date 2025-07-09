import express from "express";
import { addCourse, enrollStudent, getCourses } from "./service";

const app = express();
app.use(express.json());

app.post("/course/add", async (req, res) => {
  const { instructor, course } = req.body;
  const result = await addCourse(instructor, course);
  res.json(result);
});

app.post("/course/enroll", async (req, res) => {
  const { student, courseId } = req.body;
  const enrollment = await enrollStudent(student, courseId);
  res.json(enrollment);
});

app.get("/courses", async (req, res) => {
  const courses = await getCourses();
  res.json(courses);
});

app.listen(5000, () => console.log("Education Service running on :5000"));