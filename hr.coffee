sendCounter = (number, res) ->
  response = "![](http://pete.neisen.xyz/left.gif)"
  numberString = number.toString()
  length = numberString.length

  if length < 5
    for x in [1..(5-length)]
      response = response + "![](http://pete.neisen.xyz/0.gif)"

  for i in numberString
    response = response + "![](http://pete.neisen.xyz/#{i}.gif)"
  response = response + "![](http://pete.neisen.xyz/right.gif)"
  res.send response  

userViolationInc = (user, robot) ->
  violations = robot.brain.get('hrViolation') + 1
  userViolations = robot.brain.get("hrViolation-#{user}") + 1
  robot.brain.set 'hrViolation', violations
  robot.brain.set "hrViolation-#{user}", userViolations

  users = robot.brain.get('hrViolationUsers')
  if not users
    users = []
    users.push(user)
    robot.brain.set 'hrViolationUsers', users
  else
    if user not in users
      users.push(user)
      robot.brain.set 'hrViolationUsers', users

  return violations 
  
userViolation = (user, robot, res) ->
  sendCounter(userViolationInc(user, robot), res)

correctString = (clean, phrase) ->
  if clean
    phrase = phrase.replace /frack/ig, "fuck" 
    phrase = phrase.replace /feldman/ig, "ass" 
    phrase = phrase.replace /poop/ig, "shit" 

    return "I think you mean: \"#{phrase}\", which is an HR VIOLATION!"
  else
    phrase = phrase.replace /fuck/ig, "frack" 
    phrase = phrase.replace /ass/ig, "Feldman" 
    phrase = phrase.replace /shit/ig, "poop" 

   return "I think you mean: \"#{phrase}\"" 

module.exports = (robot) ->
  robot.hear /fuck/i, (res) ->
    if !res.message.done
      res.message.done = true
      violations = userViolationInc(res.message.user.name, robot)
      res.send correctString(false, res.message.text)
      sendCounter(violations, res)

  robot.hear /frack/i, (res) ->
    if !res.message.done
      res.message.done = true
      violations = userViolationInc(res.message.user.name, robot)
      res.send correctString(true, res.message.text)
      sendCounter(violations, res)

  robot.hear /ass/i, (res) ->
    if !res.message.done
      res.message.done = true
      violations = userViolationInc(res.message.user.name, robot)
      res.send correctString(false, res.message.text)
      sendCounter(violations, res)

  robot.hear /feldman/i, (res) ->
    if !res.message.done
      res.message.done = true
      violations = userViolationInc(res.message.user.name, robot)
      res.send correctString(true, res.message.text)
      sendCounter(violations, res)

  robot.hear /shit/i, (res) ->
    if !res.message.done
      res.message.done = true
      violations = userViolationInc(res.message.user.name, robot)
      res.send correctString(false, res.message.text)
      sendCounter(violations, res)

  robot.hear /poop/i, (res) ->
    if !res.message.done
      res.message.done = true
      violations = userViolationInc(res.message.user.name, robot)
      res.send correctString(true, res.message.text)
      sendCounter(violations, res)

  robot.hear /wtf/i, (res) ->
    if !res.message.done
      res.message.done = true
      violations = userViolationInc(res.message.user.name, robot)
      sendCounter(violations, res)

  robot.hear /hfs/i, (res) ->
    if !res.message.done
      res.message.done = true
      violations = userViolationInc(res.message.user.name, robot)
      sendCounter(violations, res)

  robot.hear /mf/i, (res) ->
    if !res.message.done
      res.message.done = true
      violations = userViolationInc(res.message.user.name, robot)
      sendCounter(violations, res)

  robot.respond /hr violation for @(.*)$/i, (res) ->
    userViolation(res.match[1].trim(), robot, res)

  robot.respond /hr violation for ([^@])(.*)$/i, (res) ->
    userViolation(res.match[1]+res.match[2].trim(), robot, res)

  robot.respond /hr violations$/i, (res) ->
    violations = robot.brain.get('hrViolation')
    sendCounter(violations, res)

  robot.respond /hr violation$/i, (res) ->
    violations = robot.brain.get('hrViolation') + 1
    robot.brain.set 'hrViolation', violations
    sendCounter(violations, res)

  robot.respond /hr violation stats/i, (res) ->
    users = robot.brain.get('hrViolationUsers')
    if !!users
      users.sort()
      response = "| Offender | Violations |\n"
      response = response + "| :------------------------ | :-----:|\n"

      total = 0
      for user in users
        num = robot.brain.get("hrViolation-#{user}")
        total = total + num
        response = response + "| #{user} | #{num} |\n"

      violations = robot.brain.get('hrViolation')
      other = violations - total
      response = response + "| other | #{other} |\n"
      response = response + "| total | #{violations} |\n"
      res.send response 

  robot.respond /hr violation help$/i, (res) ->
    response = "stabby hr violation - Click the hr violation counter\n"
    response = response + "stabby hr violations - Check the status of the hr violation counter\n"
    response = response + "stabby hr violation for <name> - Click the hr violation counter for a given person\n"
    response = response + "stabby hr violation for @<name> - Click the hr violation counter for a given person\n"
    response = response + "stabby hr violation stats - Check the stats\n"
    res.send response
