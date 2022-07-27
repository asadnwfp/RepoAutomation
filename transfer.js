// This code is used to rename files in caseware architecture
// for shifting the filesystem to a new project.
// the code will run on a folder, open any file named form.js
// change the form id to the desired id.

const OLD_ID = "com.caseware.de.e.schuellermann.taxcms.forms.assignedoverview";
const NEW_ID = "com.caseware.de.forms";
const PROJECT_PATH = `C:\\dev\\cwi_gen\\transfer`;

console.log(
  `%cOldId: ${OLD_ID} \nNewID: ${NEW_ID}\nProjectPath: ${PROJECT_PATH}`,
  "background:#dec06f; color:#52504a"
);

const fs = require("fs");
const path = require("path");

// console.log("FileName: ", __filename);
// console.log("DirName: ", __dirname );
// console.log(`BaseName: ${path.basename(__filename)}\nDirName: ${path.dirname(__filename)}\nExtName: ${path.extname(__filename)}`)

// Search content of folder

readDirector(PROJECT_PATH);

function readDirector(dirPath) {
  try {
    fs.readdir(dirPath, (err, files) => {
      console.log("Files: ", files);
      files.forEach((file) => {
        let filePath = path.resolve(dirPath, file);
        consoleFileProperties(filePath);
        if (isDirector(filePath)) {
          readDirector(filePath);
        } else {
          isForm(filePath);
        }
      });
    });
  } catch (err) {
    console.error(err);
  }
}

function isDirector(filePath) {
  try {
    const stats = fs.statSync(filePath);
    return stats.isDirectory();
  } catch (err) {
    console.error(err);
  }
}
function consoleFileProperties(filePath) {
  console.log("File: ", filePath);
  console.log(
    `BaseName: ${path.basename(filePath)}\nDirName: ${path.dirname(
      filePath
    )}\nExtName: ${path.extname(filePath)}`
  );
}

function isForm(filePath) {
  if (
    path.basename(filePath) == "form.json" &&
    path.extname(filePath) == ".json"
  ) {
    fs.readFile(filePath, (err, data) => {
      if (err) throw err;
      let ourForm = JSON.parse(data);
      id = ourForm.id.split(".forms");
      console.log("id:", id);
      console.log("id1:", id[1]);
      console.log("NewId: ", NEW_ID + id[1]);
      ourForm.id = NEW_ID + id[1];
      console.log(ourForm);
      writeToForm(filePath, ourForm);
    });
  }
}

function writeToForm(filePath, content) {
  fs.writeFile(filePath, JSON.stringify(content), (err) => {
    if (err) {
      console.error(err);
    }
    // file written successfully
  });
}
