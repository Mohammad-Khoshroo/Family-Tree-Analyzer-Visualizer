import random
import sys
import os

male_names = [
"james","john","robert","michael","william","david","richard","charles","joseph","thomas",
"christopher","daniel","paul","mark","donald","george","kenneth","steven","edward","brian",
"ronald","anthony","kevin","jason","matthew","gary","timothy","jose","larry","jeffrey",
"frank","scott","eric","stephen","andrew","raymond","gregory","joshua","jerry","dennis",
"walter","patrick","peter","harold","douglas","henry","carl","arthur","ryan","roger",
"joe","juan","jack","albert","jonathan","justin","terry","gerald","keith","samuel",
"willie","ralph","lawrence","nicholas","roy","benjamin","bruce","brandon","adam","harry",
"fred","wayne","billy","steve","louis","jeremy","aaron","randy","howard","eugene",
"carlos","russell","bobby","victor","martin","ernest","phillip","todd","jesse","craig",
"alan","shawn","clarence","sean","philip","chris","johnny","earl","jimmy","antonio",
"danny","bryan","tony","luis","mike","stanley","leonard","nathan","dale","manuel",
"rodney","curtis","norman","allen","marvin","vincent","glenn","jeffery","travis","jeff",
"chad","jacob","lee","melvin","alfred","kyle","francis","bradley","jesus","herbert",
"frederick","ray","joel","edwin","don","eddie","ricky","troy","randall","barry",
"alexander","bernard","mario","leroy","francisco","marcus","micheal","theodore","clifford","miguel",
"oscar","jay","jim","tom","calvin","alex","jon","ronnie","bill","lloyd",
"tommy","derek","warren","darrell","jerome","floyd","leo","alvin","tim","wesley",
"gordon","dean","jorge","dustin","pedro","derrick","dan","lewis","zachary","corey",
"herman","maurice","vernon","roberto","clyde","glen","hector","shane","ricardo","sam",
"rick","lester","brent","ramon","charlie","tyler","gilbert","gene","marc","reginald",
"ruben","brett","angel","nathaniel","rafael","leslie","edgar","milton","raul","ben",
"chester","cecil","duane","franklin","andre","elmer","brad","gabriel","ron","mitchell",
"roland","arnold","harvey","jared","adrian","karl","cory","claude","erik","darryl",
"jamie","neil","javier","guy","wade","raymon","rickey","trevor","fidel","manny",
"salvador","jonathon","alfonso","everett","kelvin","wilbur","darwin","jeremiah","darnell",
"emanuel","lonnie","clinton","garrett","jessie","rene","sherman","vance","vito","cesar",
"conrad","damon","dominic","eldon","elijah","emmett","ethan","freddie","gerard","grover",
"irvin","ivan","jimmie","kurt","lance","leland","leonardo","marshall","nelson","nicolas",
"noel","oliver","robbie","rocky","rodger","rufus","santiago","sergio","spencer","stacy",
"stephan","stevenson","sylvester","ted","terrance","terrence","tobias","tracy","trenton",
"tyrell","ulysses","valentino","van","virgil","wallace","willard","wilfred","xavier",
"yusuf","zane","zion","abel"
]
female_names = [
"mary","patricia","linda","barbara","elizabeth","jennifer","maria","susan","margaret","dorothy",
"lisa","nancy","karen","betty","helen","sandra","donna","carol","ruth","sharon",
"michelle","laura","sarah","kimberly","deborah","jessica","shirley","cynthia","angela","melissa",
"brenda","amy","anna","rebecca","virginia","kathleen","pamela","martha","debra","amanda",
"stephanie","carolyn","christine","marie","janet","catherine","frances","ann","joyce","diane",
"alice","julie","heather","teresa","doris","gloria","evelyn","jean","cheryl","mildred",
"katherine","joan","ashley","judith","rose","janice","kelly","nicole","judy","christina",
"kathy","theresa","beverly","denise","tammy","irene","jane","lori","rachel","marilyn",
"andrea","kathryn","louise","sara","anne","jacqueline","wanda","bonnie","julia","ruby",
"lois","tina","phyllis","norma","paula","diana","annie","lillian","emily","robin",
"peggy","crystal","gladys","rita","dawn","connie","florence","tracy","edna","tiffany",
"carmen","rosa","cindy","grace","wendy","victoria","edith","kim","sherry","sylvia",
"josephine","thelma","shannon","sheila","ethel","ellen","elaine","marjorie","carrie","charlotte",
"monica","esther","pauline","emma","juanita","anita","rhonda","hazel","amber","eva",
"debbie","april","leslie","clara","lucille","joanne","eleanor","valerie","danielle","megan",
"alicia","suzanne","michele","gail","bertha","darlene","veronica","jill","erin",
"geraldine","lauren","cathy","joann","lorraine","lynn","sally","regina","erica","beatrice",
"dolores","bernice","audrey","yvonne","annette","june","samantha","marion","dana","ana",
"margie","holly","sue","vanessa","melinda","charlene","lorena","bobbie","vicki","christy",
"tami","shari","eileen","leona","tonya","kay","minnie","patty","shelly","dorothea","kristen",
"emma","tasha","candace","faye","latoya","kristine","cecilia","raquel","hilda","gina","gwendolyn",
"mona","paige","darla","lynda","karla","elena","carla","marcie","casey","harriet","leah","penny",
"olga","katie","kristi","sonya","jacquelyn","valarie","lorri","pat","billie","dena","lana",
"yolanda","vicky","renee","delores","becky","tamara","jeanne","olivia","abigail","marlene",
"krista","sheryl","leanne","brittany","paulina","kerry","daphne","verna","suzette","lillie",
"geneva","mabel","marguerite","hattie","sabrina","nora","estelle","adeline","adele","shelley",
"melanie","sonja","deanna","patrica","rochelle","constance","tonia","gretchen","toni","marissa",
"eloise","maggie","sondra","shanna","kristin","marsha","miriam","traci","odessa","celeste",
"hannah","jana","kristy","alma","teri","lucia","kari","cathleen","beulah","priscilla","myrna",
"marian","alyssa","shelia","candi","karin","nadine","christie","betsy","joni","wilma","dianna",
"claudia","roxanne","kellie","meredith","cleo","lynne","carmella","debora","angelina","faith",
"bobbi","tammi","debby","sherrie","jennie","maritza","annmarie","rosalie","jeanette","elisa",
"vickie","carole","angelica","rosie","miriam","tanya","stacie","velma","elvira","carolina",
"lorna","genevieve","amelia","joanna","maureen","alison","shelby","roselyn","dee","faith",
"jennifer","leigh","kirsten","iris","jeanine","susie","doreen","angie","lacey","jo","cathryn",
"marcy","rosalind","rachael","jasmine","sonia","janelle","ramona","wilhelmina","ashley","molly",
"lora","francine","cassandra","tasha","ginger","felicia"
]

# --- Config ---
max_children = 6
output_dir = "tests"
os.makedirs(output_dir, exist_ok=True)

used_names = set()
family_relations = {}  # child -> set of parents


def get_name(gender):
    """Return a unique name from the appropriate list, add suffix if needed."""
    base_list = female_names if gender == "female" else male_names
    # Ensure the list is not empty
    if not base_list:
        base_list = ["DefaultFemale"] if gender == "female" else ["DefaultMale"]
        
    name = random.choice(base_list)
    orig_name = name
    counter = 2
    while name in used_names:
        name = f"{orig_name}{counter}"
        counter += 1
    used_names.add(name)
    return name


# --- Corrected Section ---
# def are_related(p1, p2):
#     """Check if two persons are siblings or have parent/child relation."""
#     # 
#     #  Your previous incorrect code was here
#     #  This logic did not correctly detect siblings
#     #
#     if p1 == p2:
#         return True
#     for parents in family_relations.values():
#         if p1 in parents and p2 in parents:  # siblings
#             return True
#         if p1 in parents and p2 in family_relations.get(p1, set()):  # p2 child of p1
#             return True
#         if p2 in parents and p1 in family_relations.get(p2, set()):  # p1 child of p2
#             return True
#     return False

def are_related(p1, p2):
    """
    Check if two persons are siblings (share the same parents).
    In this model, since marriage only occurs between people of the same generation
    (from children_list), we only need to check for siblings, not 
    parent-child relationships.
    """
    if p1 == p2:
        return True

    # Get the parents of the first person from the global dictionary
    parents1 = family_relations.get(p1)
    
    # Get the parents of the second person
    parents2 = family_relations.get(p2)

    # If both persons have registered parents and their parent sets are identical,
    # they are siblings.
    if parents1 and parents2 and parents1 == parents2:
        return True

    # Otherwise, they are not related (according to this script's logic)
    return False
# --- End of Corrected Section ---


def generate_generation(parents, stop_prob=0.07):
    """Generate children and marriages for a generation with incest prevention
       and branch stopping probability."""
    children_list = []
    facts_parent = []
    facts_gender = []
    marriages = []

    for mother, father in parents:
        # Decide if this branch should stop
        if random.random() < stop_prob:
            continue  # branch stops, no children, no marriages

        num_children = random.randint(0, max_children)
        children = []
        for _ in range(num_children):
            gender = random.choice(["male", "female"])
            child_name = get_name(gender)
            children.append((child_name, gender))
            # Record family relation
            family_relations[child_name] = {mother, father}
            # Facts
            facts_parent.append(f"parent({mother}, {child_name}).")
            facts_parent.append(f"parent({father}, {child_name}).")
            facts_gender.append(f"{gender}({child_name}).")
        children_list.extend(children)

    # create marriages for next generation
    random.shuffle(children_list)
    used = set()
    for i, (p1, g1) in enumerate(children_list):
        if p1 in used:
            continue
        # find a valid spouse
        spouse = None
        for j, (p2, g2) in enumerate(children_list):
            if i == j or p2 in used:
                continue
            
            #
            # This line now works correctly
            # (are_related(p1, p2) will return True if they are siblings)
            #
            if g1 != g2 and not are_related(p1, p2):
                spouse = p2
                used.add(p2)
                break
                
        if spouse:
            female_name = p1 if g1 == "female" else spouse
            male_name = p1 if g1 == "male" else spouse
            marriages.append((female_name, male_name))
            used.add(p1)
        else:
            # create new unrelated spouse
            if g1 == "male":
                female_name = get_name("female")
                marriages.append((female_name, p1))
            else:
                male_name = get_name("male")
                marriages.append((p1, male_name))
            used.add(p1)

    return children_list, facts_parent, facts_gender, marriages


def generate_family_tree(num_generations, output_file):
    """Generate a full family tree with generation and consistency rules."""
    global used_names, family_relations
    used_names.clear()
    family_relations.clear()

    all_facts = []
    all_facts.append("% --- Generation 1 ---")

    # Generation 1: initial couple
    gen1_female = get_name("female")
    gen1_male = get_name("male")
    all_facts.append(f"female({gen1_female}).")
    all_facts.append(f"male({gen1_male}).")
    all_facts.append(f"married({gen1_female}, {gen1_male}).")

    parents = [(gen1_female, gen1_male)]

    for gen in range(2, num_generations + 1):
        all_facts.append(f"% --- Generation {gen} ---")
        children, facts_parent, facts_gender, marriages = generate_generation(parents)
        all_facts.extend(facts_parent)
        all_facts.extend(facts_gender)
        for f, m in marriages:
            all_facts.append(f"married({f}, {m}).")
        parents = marriages

    with open(output_file, "w") as f:
        f.write("\n".join(all_facts))
    print(f"✅ Generated {output_file} with {num_generations} generations.")


# === MAIN ===
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python generate_family.py <num_tests>")
        sys.exit(1)

    try:
        num_tests = int(sys.argv[1])
    except ValueError:
        print(f"Error: <num_tests> must be an integer. Got: {sys.argv[1]}")
        sys.exit(1)

    for i in range(1, num_tests + 1):
        num_generations = random.randint(1, 7)
        output_file = os.path.join(output_dir, f"t{i:02d}_v.pl")
        generate_family_tree(num_generations, output_file)