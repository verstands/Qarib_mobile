const baseURL = 'http://185.182.186.58:4005/api';
const postSignIn = '$baseURL/auth/login';
const getRole = '$baseURL/role';
const getAllService = '$baseURL/service';
const getAllServiceByUser = '$baseURL/service/servicebyuser';
const getAllServiceByUserAll = '$baseURL/service/servicebyuserAll/servicebyuserAll';
const getSocket = 'http://185.182.186.58:4005';
const getCodeOtpMail = '$baseURL/agent/otp';
const posVerifyCompte = '$baseURL/agent/verification';
const postsaveUser = '$baseURL/agent';
const getVille = '$baseURL/ville';
const countServiceUser = '$baseURL/serviceuser/count';


//messages response
const serverError = "Aucune connexion";
const unauthorized = "Erreur de la base des données ";
const somethingwentwrong = "Quelque chose s'est mal passé, encore une fois";