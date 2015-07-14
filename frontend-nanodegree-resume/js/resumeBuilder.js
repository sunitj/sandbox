// Header
var bio = {
    "name"      :   "Sunit Jain",
    "fullName"  :   "Sunit Jain",
    "role"      :   "Bioinformatics Specialist",
    "contacts"  :   {
        "mobile"    :   "",
        "email"     :   "sunitj@umich.edu",
        "twitter"   :   "https://twitter.com/SunitJain",
        "github"    :   "https://github.com/sunitj?tab=activity",
        "linkedin"  :   "https://www.linkedin.com/in/jainsunit",
        "tumblog"   :   "http://thesunit.tumblr.com/",
        "location"  :   "https://www.google.com/maps/place/University+of+Michigan/@42.2780436,-83.7382241,15z/data=!4m2!3m1!1s0x0:0x5ba14e5178e997e3!6m1!1e1"
    },
    "biopic"     :   "images/fry.jpg",
    "welcomeMessage"   :   "Welcome to my first attampt at a JavaScript website!",
    "skills"    :   ["R","Perl","Neo4j","JavaScript"]
};
var formattedPic = HTMLbioPic.replace("%data%",bio.biopic);
var formattedName = HTMLheaderName.replace("%data%", bio.fullName);
var formattedRole = HTMLheaderRole.replace("%data%", bio.role);

var formattedSkills = HTMLskillsStart.replace("%data%",bio.skills);
var formattedEmail = addHyperLink(HTMLemail,bio.contacts.email,bio.contacts.email)
var formattedTwitter = addHyperLink(HTMLtwitter,bio.contacts.twitter, "@SunitJain");
var formattedGitHub = addHyperLink(HTMLgithub,bio.contacts.github,"sunitj");
var formattedLinkedIn = addHyperLink(HTMLlinkedIn,bio.contacts.linkedin, "Sunit Jain");
var formattedTumblog = addHyperLink(HTMLblog,bio.contacts.tumblog, "A deBugged Life");
var formattedLoc = addHyperLink(HTMLlocation,bio.contacts.location, "Ann Arbor, MI");
var formattedWelcome = HTMLwelcomeMsg.replace("%data%",bio.welcomeMessage);

$("#header").prepend(formattedRole);
$("#header").prepend(formattedName);

$("#topContacts").append(formattedEmail);
$("#topContacts").append(formattedTwitter);
$("#topContacts").append(formattedGitHub);
$("#topContacts").append(formattedLinkedIn);
$("#topContacts").append(formattedTumblog);
$("#topContacts").append(formattedLoc);

$("#header").append(formattedPic);
$("#header").append(formattedWelcome);
if (bio.skills.length > 0) {
    $("#header").append(HTMLskillsStart);
    for (var num in bio.skills) {
        var formattedSkills = HTMLskills.replace("%data%",bio.skills[num]);
        $("#skills").append(formattedSkills);
    }
}

// Work
var work = {
    "jobs"  :   [
        {
            "employer"      :   "University of Michigan",
            "title"         :   "Research Computing Specialist",
            "location"      :   "Ann Arbor, MI, USA",
            "dates"         :   "2009 - present",
            "description"   :   "Still working here!",
            "url"           :   ""
        }
    ],
    display() {
        if (work.jobs.length > 0) {
            for (var job in work.jobs) {
                $("#workExperience").append(HTMLworkStart);
                var formattedWorkEmp = HTMLworkEmployer.replace("%data%",work.jobs[job].employer);
                var formattedWorkTitle = HTMLworkTitle.replace("%data%",work.jobs[job].title);
                var catEmpTitle = formattedWorkEmp + formattedWorkTitle;
                
                var formattedWorkTime= HTMLworkDates.replace("%data%",work.jobs[job].dates);
                var formattedWorkDesc= HTMLworkDescription.replace("%data%",work.jobs[job].description);
                
                $(".work-entry:last").append(catEmpTitle);
                $(".work-entry:last").append(formattedWorkTime);
                $(".work-entry:last").append(formattedWorkDesc);
            }
        }
    }
};

work.display();

// Projects
var projects = {
    "project"   :   [
        {
            "title"     :   "SuperMom: Super Meta*omics Miner",
            "dates"     :   "November 2014 - present",
            "description"   :   "Mining meta*omic data using graph databases.",
            "images"     :   ["https://raw.githubusercontent.com/sunitj/SuperMoM/master/IMG/images/graphDB_schema.png"],
            "url"       :   "https://github.com/sunitj/SuperMoM"
        },
        {
            "title"     :   "ESOM scripts",
            "dates"     :   "August 2009 - present",
            "description"   :   "Workflow scripts for binning and visualization of metagenomic data usnig ESOM",
            "images"     :   ["images/fry.jpg"],
            "url"       :   "https://github.com/tetramerFreqs/Binning"
        },
        {
            "title"     :   "Geomicro scripts",
            "dates"     :   "August 2009 - present",
            "description"   :   "General purpose scripts to manage Biological data",
            "images"     :   [ "images/fry.jpg"],
            "url"       :   "https://github.com/Geo-omics/scripts"
        }
    ],
    display() {
        if (projects.project.length > 0) {
            for (var num in projects.project) {
                $("#projects").append(HTMLprojectStart);
                var formattedProjTitle = addHyperLink(HTMLprojectTitle, projects.project[num].url, projects.project[num].title)
                var formattedProjDates = HTMLprojectDates.replace("%data%",projects.project[num].dates);
                var formattedProjDesc = HTMLprojectDescription.replace("%data%",projects.project[num].description);
                
                $(".project-entry:last").append(formattedProjTitle);
                $(".project-entry:last").append(formattedProjDates);
                $(".project-entry:last").append(formattedProjDesc);
                
                
                if (projects.project[num].images.length > 0) {
                    for (var image in projects.project[num].images) {
                        var formattedProjImage = HTMLprojectImage.replace("%data%",projects.project[num].images[image]);
                        $(".project-entry:last").append(formattedProjImage);
                    }
                }
            }
        }
    }
    
}

projects.display();

// Education
var education = {
  "schools"     :   [
        {
        "name"      :   "University of Michigan",
        "location"      :   "Ann Arbor, MI, USA",
        "degree"    :   "Masters",
        "major"     :   ["Bioinformatics"],
        "graduation":   2011,
        "url"       :   "http://www.ccmb.med.umich.edu/"
    },
    {
        "name"      :   "Amity University",
        "location"      :   "New Delhi, India",
        "degree"    :   "B.Tech",
        "major"     :   ["Bioinformatics"],
        "graduation":   2008,
        "url"       :   "http://www.amity.edu/aib/"
    }
  ],
  "onlineCourses"   :   [
    {
        "title"     :   "JavaScript Basics",
        "school"    :   "Udacity",
        "dates"     :   "2015",
        "url"       :   "https://www.udacity.com/course/viewer#!/c-ud804/"
    },
    {
        "title"     :   "Practical Machine Learning",
        "school"    :   "Coursera",
        "dates"     :   "2015",
        "url"       :   "https://www.coursera.org/course/predmachlearn"
    },
    {
        "title"     :   "Reproducible Research",
        "school"    :   "Coursera",
        "dates"     :   "2015",
        "url"       :   "https://www.coursera.org/course/repdata"
    },    
    {
        "title"     :   "Exploratory Data Analysis",
        "school"    :   "Coursera",
        "dates"     :   "2014",
        "url"       :   "https://www.coursera.org/course/exdata"
    },
    {
        "title"     :   "Data Scientist Toolbox",
        "school"    :   "Coursera",
        "dates"     :   "2014",
        "url"       :   "https://www.coursera.org/course/datascitoolbox"
    }
  ],
    display() {
        if (education.schools.length > 0) {
            $("#education").append(HTMLschoolStart);
            for (var num in education.schools) {
                var formattedEduName = addHyperLink(HTMLschoolName,education.schools[num].url,education.schools[num].name);
                var formattedEduDegree = HTMLschoolDegree.replace("%data%", education.schools[num].degree);
                var formattedEduMajor = HTMLschoolMajor.replace("%data%", education.schools[num].major);
                var formattedEduGrad = HTMLschoolDates.replace("%data%", education.schools[num].graduation);
                var formattedEduLoc = HTMLschoolLocation.replace("%data%", education.schools[num].location);
                
                var catNameDegree = formattedEduName + formattedEduDegree;
                
                $(".education-entry:last").append(catNameDegree);
                $(".education-entry:last").append(formattedEduGrad);
                $(".education-entry:last").append(formattedEduLoc);
                $(".education-entry:last").append(formattedEduMajor);
            }
        }
        
        if (education.onlineCourses.length > 0) {
            $("#online").append(HTMLonlineStart);
            for (var num in education.onlineCourses) {
                var formattedEduTitle = addHyperLink(HTMLonlineTitle,education.onlineCourses[num].url, education.onlineCourses[num].title);
                var formattedEduName = HTMLonlineSchool.replace("%data%", education.onlineCourses[num].school);
                var formattedEduDates = HTMLonlineDates.replace("%data%", education.onlineCourses[num].dates);
                
                var catNameDegree = formattedEduTitle + formattedEduName;
                
                $(".online-entry:last").append(catNameDegree);
                $(".online-entry:last").append(formattedEduDates);
            }
        }
    }
};

education.display();

function addHyperLink(html,url,text){
    if (! text) { text = url; }
    
    var formattedURL = html.replace("#", url);
    formattedURL = formattedURL.replace("%data%",text);
    
    return formattedURL;
}

$("#footerContacts").append(formattedEmail);
$("#footerContacts").append(formattedTwitter);
$("#footerContacts").append(formattedGitHub);
$("#footerContacts").append(formattedLinkedIn);
$("#footerContacts").append(formattedTumblog);
$("#footerContacts").append(formattedLoc);

function inName(){
    var name=bio.fullName;
    var nameArray=[];
    nameArray=name.trim().split(" ");
    console.log(name);
    var newName=nameArray[0].slice(0,1).toUpperCase() + nameArray[0].slice(1).toLowerCase() +" "+ nameArray[1].toUpperCase();
    return newName;
}

$("#main").append(internationalizeButton);
$("#map-div").append(googleMap);