first_name = input("Enter First name: ") 
if first_name.istitle() and first_name.isalpha() and " " not in first_name:
    second_name = input("Enter Second name: ") 
    if second_name.istitle() and second_name.isalpha() and " " not in second_name:
        age = input("Enter your age: ")
        if age.isdigit() and " " not in second_name:
           age = int(age)
           if age >= 150:
              print("You are not eligible.")
           elif age <= 150 and age >= 18 : 
               print("You are adult")
               input("Enter Address: ")
               mob_no = input("Enter your contact number: ")
               if len(mob_no) == 10 and mob_no.isdigit() and " " not in second_name:
                    username = input("Create username: ")
                    if username.isalpha():
                       password = input("Enter your password: ")
                       if password[0].isupper() and len(password) == 8 and " " not in password:
                           if ("!" in password or "@" in password or "#" in password or "$" in password ): 
                                confirm_password = input("Confirm Password: ")
                                if password == confirm_password:
                                    print("Sign up done successfully...")
                                else:
                                    print("Your password is mismatch")
                           else:
                                print("password at least one special character")
                       else:
                            print("enter correct password")       
           elif age <= 18:
               print("You are minor.")
               input("Enter Address: ")
               mob_no = input("Enter your contact number: ")
               if len(mob_no) == 10 and mob_no.isdigit():
                    username = input("Create username: ")
                    if username.isalpha():
                       password = input("Enter your password: ")
                       if password[0].isupper() and len(password) == 8 : 
                           if ("!" in password or "@" in password or "#" in password or "$" in password): 
                                confirm_password = input("Confirm Password: ")
                                if password == confirm_password:
                                    print("Sign up done successfully...")
                                else:
                                    print("Your password is mismatch")
                           else:
                                print("password at least one special character")
                       else:
                            print("enter correct password") 
        else:
            print("Enter age in integer form.")
    else:
        print("Insert correct second name.")
else:
    print("Insert correct first name.")


# syed ali azhar



