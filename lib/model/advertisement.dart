class Advertisement {
  String title;
  String description;
  String url;
  String urlImage;
  Advertisement({required this.title, required this.description, required this.url, required this.urlImage});
}

List<Advertisement> ads = [
  Advertisement(
      title: "Google Code Jam",
      description: "Google Code Jam is an international programming competition organized by Google every year. It attracts thousands of programmers from around the world to compete and solve challenging programming problems. Participants are tested with complex algorithmic problems and must find the most optimal solutions within a limited time frame.",
      url: "https://codingcompetitionsonair.withgoogle.com/events/cj-2021",
      urlImage: "https://cdn.techjuice.pk/wp-content/uploads/2017/03/codejam.jpg" // Example image URL
  ),
  Advertisement(
      title: "Facebook Hacker Cup",
      description: "Facebook Hacker Cup is an annual programming competition organized by Facebook. It is an opportunity for programmers from all over the world to challenge themselves with difficult programming problems and compete for victory. The competition features global rounds with problems involving data structures, algorithms, and optimization.",
      url: "https://www.bing.com/search?pglt=297&q=fb+hacker+cup&cvid=49e5c8b50f8341dfae35f7474773ffb1&gs_lcrp=EgRlZGdlKgYIABBFGDkyBggAEEUYOTIGCAEQABhA0gEIMjgxNGowajGoAgCwAgA&FORM=ANNTA1&PC=U531",
      urlImage: "https://3.bp.blogspot.com/-tauilesEgAI/TwW_M38j_3I/AAAAAAAACGw/EBAAWf9HvRc/s1600/facebook_hackercup.jpg" // Example image URL
  ),
  Advertisement(
      title: "ACM ICPC",
      description: "ACM ICPC (International Collegiate Programming Contest) is a prestigious international programming competition for college students. It is held annually and is one of the largest programming contests in the world. Teams compete by solving dozens of complex problems within a few hours.",
      url: "https://icpc.global/",
      urlImage: "https://raw.githubusercontent.com/KuoE0/blog-assets/master/feature-photos/2012-12-13-2012-acm-icpc-hanoi-regional-contest.jpg" // Example image URL
  ),
  Advertisement(
      title: "TopCoder Open",
      description: "TopCoder Open is a major programming competition involving talented programmers from around the world. It is an annual event that attracts participants to compete in challenging rounds with creative and tough programming problems.",
      url: "https://www.topcoder.com/challenges/",
      urlImage: "https://news.itmo.ru/images/news/big/p12914.jpg" // Example image URL
  ),
  Advertisement(
      title: "Codeforces Global Rounds",
      description: "Codeforces Global Rounds are part of the popular Codeforces competition, organized to create an international arena for programmers. Participants face algorithmic, data structure, and optimization problems, and these competitions are often held online.",
      url: "https://codeforces.com/",
      urlImage: "https://i.ytimg.com/vi/WXnGSuvtQwU/maxresdefault.jpg" // Example image URL
  ),
  Advertisement(
      title: "HackerRank Week of Code",
      description: "HackerRank Week of Code is an online programming competition held weekly on the HackerRank platform. It is a great opportunity for programmers to practice their skills by solving algorithm and data structure problems and to join a vibrant programming community.",
      url: "https://www.hackerrank.com/domains/tutorials/10-days-of-javascript",
      urlImage: "https://th.bing.com/th/id/OIP.uRvZL3RBxYq4Xsx-L-gA2AHaD8?w=1200&h=640&rs=1&pid=ImgDetMain" // Example image URL
  ),
  Advertisement(
      title: "Kaggle Competitions",
      description: "Kaggle is a well-known platform in the field of big data and machine learning. Kaggle competitions are not only an opportunity for data analysts and programmers to solve predictive problems but also a place for engineers and data scientists to enhance their skills.",
      url: "https://www.kaggle.com/competitions",
      urlImage: "https://th.bing.com/th/id/OIP.jgLvKYZF5zsuB6RhFGtGrgHaE8?w=1000&h=667&rs=1&pid=ImgDetMain" // Example image URL
  ),
  Advertisement(
      title: "LeetCode Weekly Contests",
      description: "LeetCode is a popular platform for practicing programming problems and interview questions. LeetCode's weekly contests allow programmers to challenge themselves with new problems, improve their problem-solving skills, and compete with a global community.",
      url: "https://leetcode.com/contest/",
      urlImage: "https://i.ytimg.com/vi/81SNtt_U6jw/maxresdefault.jpg" // Example image URL
  ),
  Advertisement(
      title: "Microsoft Imagine Cup",
      description: "Microsoft Imagine Cup is an international competition for students where they can showcase their creativity and innovation using technology. It frequently attracts teams from around the world to develop projects that address important social issues.",
      url: "https://imagine.microsoft.com/",
      urlImage: "https://th.bing.com/th/id/OIP.MaYV01jNunA71VtWSxHFyQHaFj?w=1200&h=900&rs=1&pid=ImgDetMain" // Example image URL
  ),
  Advertisement(
      title: "CodeChef Long Challenge",
      description: "CodeChef Long Challenge is a 10-day online programming competition that takes place monthly on the CodeChef platform. It is an opportunity for programmers to tackle challenging problems and test their skills from beginner to advanced levels.",
      url: "https://www.codechef.com/contests",
      urlImage: "https://th.bing.com/th/id/R.6defeda25855317401dc707c72c67f9f?rik=W3Ma8ebhP72zZw&pid=ImgRaw&r=0" // Example image URL
  ),
];