module CloudBooksHelper
  
  def book_name
   #@account_name = (0...8).map{65.+(rand(26)).chr}.join

 #o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
#@account_name = (0...50).map{ o[rand(o.length)] }.join

  #@account_name = RandomWord.adjs.next  
 #@account_name = RandomWord.nouns.next

#@account_name = RandomWordGenerator.composed(2, 15)

@book_name = /\w+/.gen
@book_name.downcase
 end
  
end
